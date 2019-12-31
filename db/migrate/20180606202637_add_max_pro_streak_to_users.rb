class AddMaxProStreakToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :max_pro_streak, :integer
  end
end
