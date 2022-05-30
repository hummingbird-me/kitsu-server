require 'rails_helper'

RSpec.shared_examples 'episodic' do
  it { is_expected.to have_db_column(:episode_count) }
  it { is_expected.to have_db_column(:episode_length) }
  it { is_expected.to have_many(:episodes) }
  it { is_expected.to have_many(:streaming_links) }

  # TODO: switch these from anime-specific to general-purpose
  describe '#recalculate_episode_length!' do
    it 'sets episode_length to the mode when it is more than 50%' do
      subject.episode_count = 10
      expect(Episode).to receive(:length_mode).and_return({ mode: 5, count: 8 })
      expect(subject).to receive(:update).with(episode_length: 5)
      subject.recalculate_episode_length!
    end

    it 'sets episode_length to the mean when mode is less than 50%' do
      subject.episode_count = 10
      allow(Episode).to receive(:length_mode).and_return({ mode: 5, count: 2 })
      expect(Episode).to receive(:length_average).and_return(10)
      expect(subject).to receive(:update).with(episode_length: 10)
      subject.recalculate_episode_length!
    end
  end

  describe '#default_progress_limit' do
    context 'with a run length' do
      it 'returns a number based on the length' do
        subject.start_date = 2.weeks.ago.to_date
        subject.end_date = Time.now.utc.to_date
        expect(subject.default_progress_limit).to eq(7)
      end
    end

    context 'without a run length' do
      it 'returns 100' do
        subject.start_date = nil
        subject.end_date = nil
        expect(subject.default_progress_limit).to eq(100)
      end
    end
  end
end
