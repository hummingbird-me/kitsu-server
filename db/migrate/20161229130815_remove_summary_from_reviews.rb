class RemoveSummaryFromReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :summary
    remove_column :reviews, :legacy
  end
end
