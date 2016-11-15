class AddMoreCounterCachesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :posts_count, :integer, default: 0, null: false
    add_column :users, :ratings_count, :integer, default: 0, null: false
  end
end
