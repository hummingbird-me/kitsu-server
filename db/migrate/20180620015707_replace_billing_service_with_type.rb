class ReplaceBillingServiceWithType < ActiveRecord::Migration
  def change
    add_column :pro_subscriptions, :type, :string, null: false
    remove_column :pro_subscriptions, :billing_service
  end
end
