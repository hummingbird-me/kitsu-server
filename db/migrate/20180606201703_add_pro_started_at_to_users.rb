class AddProStartedAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :pro_started_at, :datetime
  end
end
