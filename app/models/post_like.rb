# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: post_likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null, indexed
#  user_id    :integer          not null
#
# Indexes
#
#  index_post_likes_on_post_id  (post_id)
#
# rubocop:enable Metrics/LineLength

class PostLike < ApplicationRecord
  include WithActivity

  belongs_to :user, required: true
  belongs_to :post, required: true, counter_cache: true, touch: true

  validates :post, uniqueness: { scope: :user_id }
  validate :ama_closed

  counter_culture :user, column_name: 'likes_given_count'
  counter_culture %i[post user], column_name: 'likes_received_count'

  scope :followed_first, ->(u) { joins(:user).merge(User.followed_first(u)) }

  def ama_closed
    ama = post.ama
    return unless ama
    return if ama.author == user
    now_time = Time.now

    unless ama.start_time <= now_time && ama.end_time >= now_time
      errors.add(:post, 'cannot make anymore likes on this ama')
    end
  end

  def stream_activity
    notify = [post.user.notifications] unless post.user == user
    post.feed.activities.new(
      target: post,
      to: notify
    )
  end
  after_create do
    user.update_feed_completed!
  end
end
