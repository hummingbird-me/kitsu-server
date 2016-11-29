class PolymorphizeQuotes < ActiveRecord::Migration
  def change
    rename_column :quotes, :anime_id, :media_id
    add_column :quotes, :media_type, :string, null: false

    # change_column_null :quotes, :media_id, false
  end
end
