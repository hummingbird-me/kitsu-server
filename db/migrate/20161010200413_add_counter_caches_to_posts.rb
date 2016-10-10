class AddCounterCachesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :post_likes_count, :integer, null: false, default: 0
    add_column :posts, :comments_count, :integer, null: false, default: 0
  end
end
