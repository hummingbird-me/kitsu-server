class ReplaceBillingServiceWithType < ActiveRecord::Migration[4.2]
  def change
    add_column :pro_subscriptions, :type, :string, null: false
    remove_column :pro_subscriptions, :billing_service
  end
end
