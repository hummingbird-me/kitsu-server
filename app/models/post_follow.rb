class PostFollow < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :post, optional: false

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
