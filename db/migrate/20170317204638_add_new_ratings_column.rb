class AddNewRatingsColumn < ActiveRecord::Migration[4.2]
  def up
    add_column :library_entries, :new_rating, :integer
  end

  def down
    remove_column :library_entries, :new_rating
  end
end
