class PostLike < ApplicationRecord
  include WithActivity

  belongs_to :user, optional: false
  belongs_to :post, optional: false, counter_cache: true, touch: true

  validates :post, uniqueness: { scope: :user_id }
  validates :post, active_ama: {
    message: 'cannot like this AMA',
    user: :user
  }

  counter_culture :user, execute_after_commit: true,
    column_name: proc { |model|
      model.user.likes_given_count < 20 ? 'likes_given_count' : nil
    }
  counter_culture %i[post user], execute_after_commit: true,
    column_name: proc { |model|
      'likes_received_count' if model.post.user.likes_received_count < 20
    }

  scope :followed_first, ->(u) { joins(:user).merge(User.followed_first(u)) }

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
