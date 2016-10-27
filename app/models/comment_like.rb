# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: comment_likes
#
#  id         :integer          not null, primary key
#  comment_id :integer          indexed, indexed => [user_id]
#  user_id    :integer          indexed, indexed => [comment_id]
#
# Indexes
#
#  index_comment_likes_on_comment_id              (comment_id)
#  index_comment_likes_on_user_id                 (user_id)
#  index_comment_likes_on_user_id_and_comment_id  (user_id,comment_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_c28a479c60  (comment_id => comments.id)
#  fk_rails_efcc5b56dc  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class CommentLike < ApplicationRecord
  include WithActivity

  belongs_to :user, required: true
  belongs_to :comment, required: true, counter_cache: :likes_count

  def stream_activity
    comment.post.feed.activities.new
  end
end
