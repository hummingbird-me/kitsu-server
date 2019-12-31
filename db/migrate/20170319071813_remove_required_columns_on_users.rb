class RemoveRequiredColumnsOnUsers < ActiveRecord::Migration[4.2]
  def change
    change_column_null :users, :email, true
    change_column_null :users, :name, true
    change_column_null :users, :password_digest, true
  end
end
