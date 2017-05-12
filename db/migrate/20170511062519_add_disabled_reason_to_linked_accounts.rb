class AddDisabledReasonToLinkedAccounts < ActiveRecord::Migration
  def change
    add_column :linked_accounts, :disabled_reason, :string
  end
end
