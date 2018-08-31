class RenameSubscriptionIdToBillingId < ActiveRecord::Migration
  def change
    rename_column :pro_subscriptions, :customer_id, :billing_id
  end
end
