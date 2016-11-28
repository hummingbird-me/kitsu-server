class RenameCharacterStringToCharacterId < ActiveRecord::Migration
  def change
    rename_column :quotes, :character_name, :character_id
    change_column :quotes, :character_id, :integer

    change_column_null :quotes, :character_id, false
    change_column_null :quotes, :anime_id, false
    change_column_null :quotes, :user_id, false
    change_column_null :quotes, :content, false
  end
end
