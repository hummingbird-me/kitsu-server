class AddReviewsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reviews_count, :integer, null: false, default: 0
  end
end
