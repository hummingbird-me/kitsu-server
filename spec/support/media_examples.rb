require 'rails_helper'

RSpec.shared_examples 'media' do
  include_examples 'titleable'

  before do
    allow_any_instance_of(Feed).to receive(:follow)
    allow_any_instance_of(Feed).to receive(:unfollow)
  end

  # Columns which are mandatory for all media
  it { is_expected.to have_db_column(:slug).of_type(:citext) }
  it { is_expected.to have_db_column(:abbreviated_titles).of_type(:string) }
  it { is_expected.to have_db_column(:average_rating).of_type(:decimal) }
  it { is_expected.to have_db_column(:rating_frequencies).of_type(:hstore) }
  it { is_expected.to have_db_column(:start_date).of_type(:date) }
  it { is_expected.to have_db_column(:end_date).of_type(:date) }
  it { is_expected.to have_db_column(:description).of_type(:jsonb) }
  it { is_expected.to have_and_belong_to_many(:genres) }
  it { is_expected.to have_many(:castings) }
  it { is_expected.to have_many(:library_entries) }
  # Methods used for the magic
  it { is_expected.to respond_to(:slug_candidates) }
  it { is_expected.to respond_to(:progress_limit) }
  it { is_expected.to delegate_method(:year).to(:start_date) }

  it 'ensures rating is within 0..100' do
    is_expected.to validate_numericality_of(:average_rating)
      .is_less_than_or_equal_to(100)
      .is_greater_than(0)
  end

  describe '#run_length' do
    context 'with a start date' do
      it 'returns the period from start_date to end_date' do
        subject.start_date = 6.months.ago.to_date
        subject.end_date = 3.months.ago.to_date
        expect(subject.run_length).to be_within(5).of(90) # 90 days = 3 months
      end
    end

    context 'without a start date' do
      it 'returns nil' do
        subject.start_date = nil
        subject.end_date = 3.months.ago.to_date
        expect(subject.run_length).to be_nil
      end
    end

    context 'without an end date' do
      it 'returns the period from start_date to today' do
        subject.start_date = 2.months.ago.to_date
        subject.end_date = nil
        expect(subject.run_length).to be_within(5).of(60) # 60 days = 2 months
      end
    end

    context 'with a start_date in the future' do
      it 'returns nil' do
        subject.start_date = 2.months.from_now.to_date
        subject.end_date = nil
        expect(subject.run_length).to be_nil
      end
    end
  end

  describe '#calculate_rating_frequencies' do
    context 'with no library entries' do
      it 'returns a Hash of zeroes' do
        subject.save!
        freqs = subject.calculate_rating_frequencies
        expect(freqs).to include(2)
        expect(freqs).to include(7)
        expect(freqs).to include(13)
        expect(freqs).to include(17)
        expect(freqs.values).to all(eq(0))
      end
    end

    context 'with a couple library entries' do
      it 'returns the count of each rating in a Hash' do
        subject.save!
        create_list(:library_entry, 3, media: subject, rating: 3)
        freqs = subject.calculate_rating_frequencies
        expect(freqs[3]).to eq(3)
      end
    end
  end

  describe '#decrement_rating_frequency' do
    it 'decrements the rating frequency' do
      Sidekiq::Testing.inline! do
        subject.rating_frequencies['3'] = 5
        subject.save!
        subject.decrement_rating_frequency('3')
        subject.reload
        expect(subject.rating_frequencies['3']).to eq('4')
      end
    end
  end

  describe '#increment_rating_frequency' do
    it 'increments the rating frequency' do
      Sidekiq::Testing.inline! do
        subject.rating_frequencies['3'] = 5
        subject.save!
        subject.increment_rating_frequency('3')
        subject.reload
        expect(subject.rating_frequencies['3']).to eq('6')
      end
    end

    context 'without a pre-existing value' do
      it 'assumes zero' do
        Sidekiq::Testing.inline! do
          subject.save!
          subject.increment_rating_frequency('3')
          subject.reload
          expect(subject.rating_frequencies['3']).to eq('1')
        end
      end
    end
  end

  describe '#feed' do
    it 'returns a feed for the media' do
      expect(subject.feed).to be_a(MediaFeed)
    end
  end

  describe 'after creating' do
    it 'calls #setup! on the feed' do
      feed = instance_spy(Feed).as_null_object
      allow(subject).to receive(:feed).and_return(feed)
      subject.save!
      expect(subject.feed).to have_received(:setup!)
    end
  end

  describe '#sanitize_description' do
    it 'strips XSS from description' do
      subject.description['en'] = '<script>prompt("PASSWORD:")</script>' * 3
      subject.save!
      expect(subject.description['en']).not_to include('<script>')
    end
  end
end
