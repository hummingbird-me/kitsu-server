class AddSpoilerToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :spoiler, :boolean, default: false, null: false
  end
end
