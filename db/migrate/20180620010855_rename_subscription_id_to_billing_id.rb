class RenameSubscriptionIdToBillingId < ActiveRecord::Migration[4.2]
  def change
    rename_column :pro_subscriptions, :customer_id, :billing_id
  end
end
