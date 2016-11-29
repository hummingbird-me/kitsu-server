class UpdateQuotes < ActiveRecord::Migration
  def change
    change_column_null :quotes, :anime_id, false
    change_column_null :quotes, :user_id, false
    change_column_null :quotes, :content, false

    add_foreign_key :quotes, :users
    add_foreign_key :quotes, :anime
    add_foreign_key :quotes, :characters
  end
end
