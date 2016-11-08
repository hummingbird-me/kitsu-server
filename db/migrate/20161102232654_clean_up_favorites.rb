class CleanUpFavorites < ActiveRecord::Migration
  def change
    change_column_null :favorites, :user_id, false
    change_column_null :favorites, :item_id, false
    change_column_null :favorites, :item_type, false
    change_column_null :favorites, :fav_rank, false, 9999
  end
end
