class AddCommentLikes < ActiveRecord::Migration
  def change
    create_table :comment_likes do |t|
      t.references :comment, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.index [:user_id, :comment_id], unique: true
    end
    add_column :comments, :likes_count, :integer, null: false, default: 0
  end
end
