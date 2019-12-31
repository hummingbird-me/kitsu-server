class RemoveSummaryFromReviews < ActiveRecord::Migration[4.2]
  def change
    remove_column :reviews, :summary
    remove_column :reviews, :legacy
  end
end
