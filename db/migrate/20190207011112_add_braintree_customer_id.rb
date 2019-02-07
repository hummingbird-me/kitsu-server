class AddBraintreeCustomerId < ActiveRecord::Migration
  def change
    add_column :users, :braintree_customer_id, :string
  end
end
