class AddProgressToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :progress, :integer
  end
end
