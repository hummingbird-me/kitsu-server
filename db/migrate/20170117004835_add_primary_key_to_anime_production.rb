class AddPrimaryKeyToAnimeProduction < ActiveRecord::Migration[4.2]
  def change
    add_column :anime_productions, :id, :primary_key
  end
end
