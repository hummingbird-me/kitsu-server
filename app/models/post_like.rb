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

class PostLike < ApplicationRecord
  has_paper_trail
  include WithActivity

  belongs_to :user, required: true
  belongs_to :post, required: true, counter_cache: true, touch: true

  validates :post, uniqueness: { scope: :user_id }

  counter_culture :user, column_name: 'likes_given_count'
  counter_culture %i[post user], column_name: 'likes_received_count'

  def stream_activity
    post.feed.activities.new(
      target: post,
      to: [post.user.notifications]
    )
  end

  after_create { user.update_feed_completed! }
end
