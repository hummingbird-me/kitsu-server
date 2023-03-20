class AddAppleIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :apple_id, :string
    add_index :users, :apple_id, unique: true
  end
end
