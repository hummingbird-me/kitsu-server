class AddIndicesToLibraryEntries < ActiveRecord::Migration
  self.disable_ddl_transaction!

  def change
    add_index :library_entries, :anime_id, algorithm: :concurrently
    add_index :library_entries, :manga_id, algorithm: :concurrently
    add_index :library_entries, :drama_id, algorithm: :concurrently
  end
end
