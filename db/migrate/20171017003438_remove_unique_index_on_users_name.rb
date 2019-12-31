class RemoveUniqueIndexOnUsersName < ActiveRecord::Migration[4.2]
  def change
    execute 'DROP INDEX IF EXISTS index_users_on_lower_name_index'
  end
end
