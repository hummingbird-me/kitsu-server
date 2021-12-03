class CommentLike < ApplicationRecord
  include WithActivity

  belongs_to :user, required: true
  belongs_to :comment, required: true, counter_cache: :likes_count, touch: true

  validates :comment, uniqueness: { scope: :user_id }
  validates :comment, active_ama: {
    message: 'cannot like comments on this AMA',
    user: :user
  }

  def stream_activity
    notify = [comment.user.notifications] unless comment.user == user
    comment.post.feed.activities.new(
      target: comment,
      to: notify
    )
  end
end
