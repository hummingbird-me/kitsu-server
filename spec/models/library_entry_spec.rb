require 'rails_helper'

RSpec.describe LibraryEntry, type: :model do
  let(:anime) { create(:anime, episode_count: 5) }
  subject { build(:library_entry) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:media) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:progress) }
  it { should validate_presence_of(:reconsume_count) }
  it 'should validate uniqueness of anime per user' do
    user = create(:user)
    anime = create(:anime)
    create(:library_entry, user: user, anime: anime, media: nil)
    new_entry = build(:library_entry, user: user, anime: anime, media: nil)
    expect(new_entry).not_to be_valid
    expect(new_entry.errors[:anime_id].count).not_to be_zero
  end
  it 'should validate uniqueness of anime per user' do
    user = create(:user)
    drama = create(:drama)
    create(:library_entry, user: user, drama: drama, media: nil)
    new_entry = build(:library_entry, user: user, drama: drama, media: nil)
    expect(new_entry).not_to be_valid
    expect(new_entry.errors[:drama_id].count).not_to be_zero
  end
  it 'should validate uniqueness of anime per user' do
    user = create(:user)
    manga = create(:manga)
    create(:library_entry, user: user, manga: manga, media: nil)
    new_entry = build(:library_entry, user: user, manga: manga, media: nil)
    expect(new_entry).not_to be_valid
    expect(new_entry.errors[:manga_id].count).not_to be_zero
  end
  it do
    expect(subject).to validate_numericality_of(:rating)
      .is_less_than_or_equal_to(20)
      .is_greater_than_or_equal_to(2)
  end

  describe 'media_present validation' do
    let(:anime) { build(:anime) }
    let(:manga) { build(:manga) }
    context 'with multiple media present' do
      let(:library_entry) { build(:library_entry, anime: anime, manga: manga) }
      it 'should fail validation' do
        expect(library_entry).not_to be_valid
        expect(library_entry.errors[:anime]).to be_present
      end
    end

    context 'with single media present' do
      let(:library_entry) { build(:library_entry, anime: anime) }
      it 'should pass validation' do
        expect(library_entry).to be_valid
        expect(library_entry.errors[:anime]).not_to be_present
      end
    end
  end

  describe 'progress_limit validation' do
    context 'with known progress_limit' do
      let(:anime) { build(:anime, episode_count: 5) }
      it 'should fail when progress > progress_limit' do
        library_entry = build(:library_entry, media: anime, progress: 6)
        expect(library_entry).not_to be_valid
        expect(library_entry.errors[:progress]).to be_present
      end
      it 'should pass when progress <= progress_limit' do
        library_entry = build(:library_entry, media: anime, progress: 4)
        library_entry.valid?
        expect(library_entry.errors[:progress]).to be_blank
      end
    end
    context 'without known progress_limit' do
      let(:anime) { build(:anime, episode_count: nil) }
      it 'should fail when progress > default_progress_limit' do
        library_entry = build(:library_entry, media: anime, progress: 200)
        expect(anime).to receive(:default_progress_limit).and_return(100).once
        expect(library_entry).not_to be_valid
        expect(library_entry.errors[:progress]).to be_present
      end
      it 'should pass when progress <= default_progress_limit' do
        library_entry = build(:library_entry, media: anime, progress: 70)
        expect(anime).to receive(:default_progress_limit).and_return(100).once
        library_entry.valid?
        expect(library_entry.errors[:progress]).to be_blank
      end
      it 'should ignore default progress limits below 50' do
        library_entry = build(:library_entry, media: anime, progress: 40)
        expect(anime).to receive(:default_progress_limit).and_return(10).once
        library_entry.valid?
        expect(library_entry.errors[:progress]).to be_blank
      end
    end
  end

  describe 'timestamp validation' do
    let!(:library_entry) do
      create(:library_entry, media: anime, status: :current, progress: 1)
    end
    context 'progressed_at validation' do
      it 'should set progressed_at when progress is changed' do
        expect(library_entry.progressed_at).to be_present
      end
    end
    context 'started_at validation' do
      it 'should set started_at when status is current' do
        expect(library_entry.started_at).to be_present
      end
      it 'should not change started_at' do
        started_at = library_entry.started_at
        library_entry.status = :on_hold
        library_entry.save!
        library_entry.status = :current
        library_entry.save!
        expect(library_entry.started_at).to eq(started_at)
      end
    end
    context 'finished_at validation' do
      let!(:library_entry) do
        create(:library_entry, media: anime, status: :completed)
      end
      it 'should set finished_at and started_at when status is completed' do
        expect(library_entry.finished_at).to be_present
        expect(library_entry.started_at).to be_present
      end
      it 'should not change finished_at' do
        finished_at = library_entry.finished_at
        library_entry.status = :current
        library_entry.save!
        library_entry.status = :completed
        library_entry.save!
        expect(library_entry.finished_at).to eq(finished_at)
      end
    end
  end

  describe 'synchronizing media and anime/manga/drama_id' do
    it 'should copy media into the new, non-polymorphic association' do
      anime = build(:anime)
      le = build(:library_entry, media: anime)
      le.valid?
      expect(le.anime).to eq(anime)
    end
  end
end
