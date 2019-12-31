class AddBraintreeCustomerId < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :braintree_customer_id, :string
  end
end
