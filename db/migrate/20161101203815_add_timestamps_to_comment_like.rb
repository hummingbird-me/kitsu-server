class AddTimestampsToCommentLike < ActiveRecord::Migration[4.2]
  def change
    add_timestamps :comment_likes, null: false
  end
end
