class AddSessionDataToLinkedAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :linked_accounts, :session_data, :text
  end
end
