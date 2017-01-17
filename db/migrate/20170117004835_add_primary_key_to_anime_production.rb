class AddPrimaryKeyToAnimeProduction < ActiveRecord::Migration
  def change
    add_column :anime_productions, :id, :primary_key
  end
end
