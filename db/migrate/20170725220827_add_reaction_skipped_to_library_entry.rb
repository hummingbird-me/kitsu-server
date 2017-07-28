class AddReactionSkippedToLibraryEntry < ActiveRecord::Migration
  def change
    add_column :library_entries, :reaction_skipped, :integer
  end
end
