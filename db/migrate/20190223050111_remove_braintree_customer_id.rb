class RemoveBraintreeCustomerId < ActiveRecord::Migration
  def change
    remove_column :users, :braintree_customer_id
  end
end
