class AddConsecutiveDaysToUser < ActiveRecord::Migration
  def change
    add_column :users, :consecutive_days, :integer, default: 0, null: false
    add_column :users, :last_login, :datetime
  end
end
