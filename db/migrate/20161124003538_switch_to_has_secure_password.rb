class SwitchToHasSecurePassword < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :encrypted_password, :password_digest
  end
end
