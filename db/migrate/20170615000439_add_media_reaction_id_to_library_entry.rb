class AddMediaReactionIdToLibraryEntry < ActiveRecord::Migration
  def change
    # Disable timeout
    ActiveRecord::Base.connection.execute('SET statement_timeout = 0')
    add_column :library_entries, :media_reaction_id, :integer
    add_foreign_key :library_entries, :media_reactions
  end
end
