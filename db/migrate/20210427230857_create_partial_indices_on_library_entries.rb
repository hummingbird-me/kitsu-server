class CreatePartialIndicesOnLibraryEntries < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change
    add_index :library_entries, :manga_id,
      where: 'manga_id IS NOT NULL',
      algorithm: :concurrently,
      name: 'index_library_entries_on_manga_id_partial'
    add_index :library_entries, :anime_id,
      where: 'anime_id IS NOT NULL',
      algorithm: :concurrently,
      name: 'index_library_entries_on_anime_id_partial'
  end
end
