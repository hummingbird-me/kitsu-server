class RemoveUniqueIndexOnUsersName < ActiveRecord::Migration
  def change
    execute 'DROP INDEX IF EXISTS index_users_on_lower_name_index'
  end
end
