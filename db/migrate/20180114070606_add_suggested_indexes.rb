class AddSuggestedIndexes < ActiveRecord::Migration
  def change
    commit_db_transaction
    add_index :characters, [:slug], algorithm: :concurrently
    add_index :comments, [:user_id], algorithm: :concurrently
    add_index :library_events, [:library_entry_id], algorithm: :concurrently
    add_index :manga, [:slug], algorithm: :concurrently
    add_index :post_likes, [:user_id], algorithm: :concurrently
  end
end
