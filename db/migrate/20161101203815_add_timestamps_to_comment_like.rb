class AddTimestampsToCommentLike < ActiveRecord::Migration
  def change
    add_timestamps :comment_likes, null: false
  end
end
