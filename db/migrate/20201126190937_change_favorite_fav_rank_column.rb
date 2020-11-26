class ChangeFavoriteFavRankColumn < ActiveRecord::Migration[5.1]
  def change
    change_column_null :favorites, :fav_rank, true
    change_column_default :favorites, :fav_rank, from: 9999, to: nil
  end
end
