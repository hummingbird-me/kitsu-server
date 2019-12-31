class AddFavoritesCountToMedia < ActiveRecord::Migration[4.2]
  def change
    add_column :anime, :favorites_count, :integer, null: false, default: 0
    add_column :manga, :favorites_count, :integer, null: false, default: 0
    add_column :dramas, :favorites_count, :integer, null: false, default: 0
  end
end
