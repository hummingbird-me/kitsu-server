class AddReactionSkippedToLibraryEntry < ActiveRecord::Migration[4.2]
  def change
    add_column :library_entries, :reaction_skipped, :integer
  end
end
