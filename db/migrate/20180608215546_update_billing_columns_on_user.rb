class UpdateBillingColumnsOnUser < ActiveRecord::Migration
  def change
    remove_column :users, :pro_membership_plan_id
    remove_column :users, :stripe_token
    remove_column :users, :stripe_customer_id
  end
end
