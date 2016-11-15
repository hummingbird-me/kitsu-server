class AddNsfwToLibraryEntries < ActiveRecord::Migration
  def change
    add_column :library_entries, :nsfw, :boolean, default: false, null: false
  end
end
