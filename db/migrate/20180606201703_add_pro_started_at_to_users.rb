class AddProStartedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pro_started_at, :datetime
  end
end
