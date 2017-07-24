# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
#  hidden      :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer          indexed => [follower_id]
#  follower_id :integer          indexed, indexed => [followed_id]
#
# Indexes
#
#  index_follows_on_followed_id                  (follower_id)
#  index_follows_on_followed_id_and_follower_id  (followed_id,follower_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

class Follow < ApplicationRecord
  include WithActivity

  belongs_to :follower, class_name: 'User', required: true,
                        counter_cache: :following_count, touch: true
  belongs_to :followed, class_name: 'User', required: true,
                        counter_cache: :followers_count, touch: true

  validates :followed, uniqueness: { scope: :follower_id }

  def stream_activity
    follower.profile_feed.no_fanout.activities.new(
      actor: follower,
      followed: followed,
      to: [followed.notifications]
    )
  end

  def validate_not_yourself
    errors.add(:followed, 'cannot follow yourself') if follower == followed
  end
  validate :validate_not_yourself

  # Set up follows in Stream
  after_commit(on: :create) do
    follower.timeline.follow(followed.profile_feed) unless hidden?
  end
  after_commit(on: :update, if: :hidden_changed?) do
    if hidden?
      follower.timeline.unfollow(followed.profile_feed)
    else
      follower.timeline.follow(followed.profile_feed)
    end
  end
  after_commit(on: :destroy) do
    follower.timeline.unfollow(followed.profile_feed)
  end

  # Update onboarding
  after_create { follower.update_feed_completed! }
end
