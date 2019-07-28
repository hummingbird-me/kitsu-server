# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: library_entries
#
#  id                :integer          not null, primary key
#  finished_at       :datetime
#  media_type        :string           not null, indexed => [user_id], indexed => [user_id, media_id]
#  notes             :text
#  nsfw              :boolean          default(FALSE), not null
#  private           :boolean          default(FALSE), not null, indexed
#  progress          :integer          default(0), not null
#  progressed_at     :datetime
#  rating            :integer
#  reaction_skipped  :integer          default(0), not null
#  reconsume_count   :integer          default(0), not null
#  reconsuming       :boolean          default(FALSE), not null
#  started_at        :datetime
#  status            :integer          not null, indexed => [user_id]
#  time_spent        :integer          default(0), not null
#  volumes_owned     :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  anime_id          :integer          indexed
#  drama_id          :integer          indexed
#  manga_id          :integer          indexed
#  media_id          :integer          not null, indexed => [user_id, media_type]
#  media_reaction_id :integer
#  user_id           :integer          not null, indexed, indexed => [media_type], indexed => [media_type, media_id], indexed => [status]
#
# Indexes
#
#  index_library_entries_on_anime_id                             (anime_id)
#  index_library_entries_on_drama_id                             (drama_id)
#  index_library_entries_on_manga_id                             (manga_id)
#  index_library_entries_on_private                              (private)
#  index_library_entries_on_user_id                              (user_id)
#  index_library_entries_on_user_id_and_media_type               (user_id,media_type)
#  index_library_entries_on_user_id_and_media_type_and_media_id  (user_id,media_type,media_id) UNIQUE
#  index_library_entries_on_user_id_and_status                   (user_id,status)
#
# Foreign Keys
#
#  fk_rails_a7e4cb3aba  (media_reaction_id => media_reactions.id)
#
# rubocop:enable Metrics/LineLength

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

  describe 'updating rating_frequencies on media after save' do
    before { skip 'needs to be tested separately as the sidekiq worker tbh' }
    context 'with a previous value' do
      it 'should decrement the previous frequency' do
        Sidekiq::Testing.inline! do
          library_entry = create(:library_entry, rating: 3)
          media = library_entry.media
          expect {
            library_entry.rating = 4
            library_entry.save!
          }.to change { media.reload.rating_frequencies['3'].to_i }.by(-1)
        end
      end
      it 'should increment the new frequency' do
        Sidekiq::Testing.inline! do
          library_entry = create(:library_entry, rating: 3)
          media = library_entry.media
          expect {
            library_entry.rating = 4
            library_entry.save!
          }.to change { media.reload.rating_frequencies['4'].to_i }.by(1)
        end
      end
    end
    context 'without a previous value' do
      it 'should not send any frequencies negative' do
        library_entry = create(:library_entry, rating: 3)
        media = library_entry.media
        library_entry.rating = 4
        library_entry.save!
        media.reload
        freqs = media.rating_frequencies.transform_values(&:to_i)
        expect(freqs.values).to all(be_positive.or(be_zero))
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
