class SwitchFromLengthToTier < ActiveRecord::Migration[4.2]
  def change
    rename_column :pro_subscriptions, :plan, :tier
    add_column :users, :pro_tier, :integer
    User.where.not(ao_pro: nil).update_all('pro_tier = ao_pro')
  end
end
