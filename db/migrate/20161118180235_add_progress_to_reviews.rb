class AddProgressToReviews < ActiveRecord::Migration[4.2]
  def change
    add_column :reviews, :progress, :integer
  end
end
