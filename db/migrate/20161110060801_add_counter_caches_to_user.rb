class AddCounterCachesToUser < ActiveRecord::Migration
  def change
    add_column :users, :comments_count, :integer, default: 0, null: false
    add_column :users, :likes_given_count, :integer, default: 0, null: false
    add_column :users, :likes_received_count, :integer, default: 0, null: false
    add_column :users, :favorites_count, :integer, default: 0, null: false
  end
end
