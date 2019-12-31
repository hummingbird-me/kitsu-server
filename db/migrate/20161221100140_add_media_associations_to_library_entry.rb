class AddMediaAssociationsToLibraryEntry < ActiveRecord::Migration[4.2]
  def change
    add_reference :library_entries, :anime
    add_reference :library_entries, :manga
    add_reference :library_entries, :drama
  end
end
