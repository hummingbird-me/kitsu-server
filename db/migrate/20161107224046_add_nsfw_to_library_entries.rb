class AddNsfwToLibraryEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :library_entries, :nsfw, :boolean, default: false, null: false
  end
end
