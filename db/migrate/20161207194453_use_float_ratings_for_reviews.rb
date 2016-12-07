class UseFloatRatingsForReviews < ActiveRecord::Migration
  class Review < ActiveRecord::Base; end
  def change
    Review.where(rating: 0).update_all(rating: 1)
    change_column :reviews, :rating, :float
    execute 'UPDATE reviews SET rating = rating / 2.0'
  end
end
