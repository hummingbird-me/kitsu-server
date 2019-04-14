class AddStateToProSubscriptions < ActiveRecord::Migration
  def change
    add_column :pro_subscriptions, :state, :integer, default: 0, null: false
    add_column :pro_subscriptions, :error, :string
  end
end
