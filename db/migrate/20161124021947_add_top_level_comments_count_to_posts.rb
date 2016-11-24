class AddTopLevelCommentsCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :top_level_comments_count, :integer, default: 0, null: false
  end
end
