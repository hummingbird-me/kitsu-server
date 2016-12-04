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
# Foreign Keys
#
#  fk_rails_a04bfa7e81  (post_id => posts.id)
#  fk_rails_d07653f350  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class PostLike < ApplicationRecord
  include WithActivity

  belongs_to :user, required: true
  belongs_to :post, required: true, counter_cache: true, touch: true

  validates :post, uniqueness: { scope: :user_id }

  counter_culture :user, column_name: 'likes_given_count'
  counter_culture [:post, :user], column_name: 'likes_received_count'

  def stream_activity
    post.feed.activities.new(
      target: post,
      to: [post.user.notifications]
    )
  end
end
