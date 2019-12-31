class AddDisabledReasonToLinkedAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :linked_accounts, :disabled_reason, :string
  end
end
