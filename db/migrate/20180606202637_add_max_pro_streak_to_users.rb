class AddMaxProStreakToUsers < ActiveRecord::Migration
  def change
    add_column :users, :max_pro_streak, :integer
  end
end
