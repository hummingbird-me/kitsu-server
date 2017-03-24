# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
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
    follower.aggregated_feed.activities.new(
      actor: follower,
      followed: followed,
      to: [followed.notifications]
    )
  end

  def validate_not_yourself
    errors.add(:followed, 'cannot follow yourself') if follower == followed
  end
  validate :validate_not_yourself

  after_create do
    follower.timeline.follow(followed.posts_feed)
    follower.timeline.follow(followed.media_feed)
    follower.posts_timeline.follow(followed.posts_feed)
    follower.media_timeline.follow(followed.media_feed)
  end

  after_destroy do
    follower.timeline.unfollow(followed.posts_feed)
    follower.timeline.unfollow(followed.media_feed)
    follower.posts_timeline.unfollow(followed.posts_feed)
    follower.media_timeline.unfollow(followed.media_feed)
  end

  after_create { follower.update_feed_completed! }
end
