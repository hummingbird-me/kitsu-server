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
  belongs_to :follower, class_name: 'User', required: true,
    counter_cache: :following_count, touch: true
  belongs_to :followed, class_name: 'User', required: true,
    counter_cache: :followers_count, touch: true

  def validate_not_yourself
    errors.add(:followed, 'cannot follow yourself') if follower == followed
  end
  validate :validate_not_yourself

  after_save do
    follower.feed.follow(followed.feed)
  end

  after_destroy do
    follower.feed.unfollow(followed.feed)
  end
end
