class AddAgeRatingsToManga < ActiveRecord::Migration[4.2]
  def change
    add_column :manga, :age_rating, :integer, index: true
    add_column :manga, :age_rating_guide, :string
  end
end
