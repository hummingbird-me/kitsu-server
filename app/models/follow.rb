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

  def self.following_all(*users)
    users = users.map { |u| u.id if u.respond_to? :id }
    expected_count = users.count
    where(followed_id: users).group(:follower_id)
                             .having('count(*) = ?', expected_count).count.keys
  end

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
    follower.timeline.follow(followed.feed)
  end

  after_destroy do
    follower.timeline.unfollow(followed.feed)
  end

  after_create { follower.update_feed_completed! }
end
