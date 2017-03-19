class ChangeAverageRatingColumn < ActiveRecord::Migration
  def change
    change_column :anime, :average_rating, :decimal, precision: 5, scale: 2
    change_column :manga, :average_rating, :decimal, precision: 5, scale: 2
    change_column :dramas, :average_rating, :decimal, precision: 5, scale: 2
  end
end
