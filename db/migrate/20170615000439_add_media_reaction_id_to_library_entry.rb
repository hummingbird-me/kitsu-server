class AddMediaReactionIdToLibraryEntry < ActiveRecord::Migration
  def change
    add_column :library_entries, :media_reaction_id, :integer
    add_foreign_key :library_entries, :media_reactions
  end
end
