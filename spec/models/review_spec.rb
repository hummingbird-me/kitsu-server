# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: reviews
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime         indexed
#  likes_count       :integer          default(0), indexed
#  media_type        :string
#  progress          :integer
#  rating            :float            not null
#  source            :string(255)
#  spoiler           :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  library_entry_id  :integer
#  media_id          :integer          not null, indexed
#  user_id           :integer          not null, indexed
#
# Indexes
#
#  index_reviews_on_deleted_at   (deleted_at)
#  index_reviews_on_likes_count  (likes_count)
#  index_reviews_on_media_id     (media_id)
#  index_reviews_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_150e554f22  (library_entry_id => library_entries.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { build(:user, id: 1) }

  subject { build(:review, user: user) }
  it { should have_many(:likes).class_name('ReviewLike') }
  it { should belong_to(:media) }
  it { should validate_presence_of(:media) }
  it 'should validate uniqueness per media and user' do
    subject.save!
    expect(subject).to validate_uniqueness_of(:media_id).scoped_to(:user_id)
  end
  it { should belong_to(:user).counter_cache(true) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:library_entry) }
  it { should validate_presence_of(:library_entry) }
  it { should validate_presence_of(:content) }

  describe '#steam_activity' do
    it 'publishes the activity to the user\'s media feed' do
      expect(subject.stream_activity.feed).to eq(subject.user.profile_feed)
    end

    it 'copies the activity to the media\'s media feed' do
      expect(subject.stream_activity[:to]).to(
        include(subject.media.feed)
      )
    end
  end
end
