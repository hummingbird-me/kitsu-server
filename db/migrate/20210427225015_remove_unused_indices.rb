class RemoveUnusedIndices < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change
    # We no longer use substories
    remove_index :substories, :created_at
    remove_index :substories, :deleted_at
    remove_index :substories, :story_id
    remove_index :substories, :target_id
    remove_index :substories, :user_id
    # We already have LibraryEntries (user_id, media_type, media_id) so PG just uses prefix
    remove_index :library_entries, %i[user_id media_type]
    # These indexes are extremely space-inefficient and aren't used anyways
    remove_index :library_events, :manga_id
    remove_index :library_events, :anime_id
    remove_index :library_events, :drama_id
    # Replace them with partial indices
    add_index :library_events, :manga_id, where: 'manga_id IS NOT NULL', algorithm: :concurrently
    add_index :library_events, :anime_id, where: 'anime_id IS NOT NULL', algorithm: :concurrently
    add_index :library_events, :drama_id, where: 'drama_id IS NOT NULL', algorithm: :concurrently
  end
end
