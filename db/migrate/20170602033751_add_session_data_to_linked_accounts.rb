class AddSessionDataToLinkedAccounts < ActiveRecord::Migration
  def change
    add_column :linked_accounts, :session_data, :text
  end
end
