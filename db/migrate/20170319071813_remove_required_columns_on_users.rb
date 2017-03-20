class RemoveRequiredColumnsOnUsers < ActiveRecord::Migration
  def change
    change_column_null :users, :email, true
    change_column_null :users, :name, true
    change_column_null :users, :password_digest, true
  end
end
