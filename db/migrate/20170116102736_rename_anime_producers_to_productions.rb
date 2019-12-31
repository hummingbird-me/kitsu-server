class RenameAnimeProducersToProductions < ActiveRecord::Migration[4.2]
  def change
    rename_table :anime_producers, :anime_productions
    add_column :anime_productions, :role, :integer, default: 0
  end
end
