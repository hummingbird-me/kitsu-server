class RemoveBraintreeCustomerId < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :braintree_customer_id
  end
end
