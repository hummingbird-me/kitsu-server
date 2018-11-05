class AddPlanToProSubscriptions < ActiveRecord::Migration
  def change
    add_column :pro_subscriptions, :plan, :integer, default: 0, null: false
  end
end
