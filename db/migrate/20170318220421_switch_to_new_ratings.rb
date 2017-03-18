class SwitchToNewRatings < ActiveRecord::Migration
  def change
    missed_entries = LibraryEntry.where(new_rating: nil).where.not(rating: nil)
    missed_entries.update_all('new_rating = (rating * 4) - 1')
    remove_column :library_entries, :rating
    rename_column :library_entries, :new_rating, :rating
  end
end
