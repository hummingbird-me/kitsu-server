class CreateProSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :pro_subscriptions do |t|
      t.references :user, null: false
      t.integer :billing_service, null: false
      t.string :customer_id, null: false
      t.timestamps null: false
    end
    add_index :pro_subscriptions, :user_id
  end
end
