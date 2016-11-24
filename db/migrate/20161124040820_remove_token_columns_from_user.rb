class RemoveTokenColumnsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :confirmation_token
    remove_column :users, :confirmation_sent_at
    remove_column :users, :reset_password_sent_at
    remove_column :users, :reset_password_token
  end
end
