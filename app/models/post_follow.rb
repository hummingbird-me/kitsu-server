# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: post_follows
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          indexed
#  user_id    :integer          indexed
#
# Indexes
#
#  index_post_follows_on_post_id  (post_id)
#  index_post_follows_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_8cdaf33e9c  (user_id => users.id)
#  fk_rails_afb3620fdd  (post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

class PostFollow < ApplicationRecord
  belongs_to :user, required: true, touch: true
  belongs_to :post, required: true

  validates :post, uniqueness: { scope: :user_id }
  validates :post, active_ama: {
    message: 'cannot follow this AMA',
    user: :user
  }

  after_commit(on: :create) do
    user.notifications.follow(post.comments_feed, scrollback: 0)
  end

  after_commit(on: :destroy) do
    user.notifications.unfollow(post.comments_feed)
  end
end
