class AddEncryptionToLpToken < ActiveRecord::Migration
  def change
    rename_column :linked_profiles, :token, :encrypted_token
    add_column :linked_profiles, :encrypted_token_iv, :string
  end
end
