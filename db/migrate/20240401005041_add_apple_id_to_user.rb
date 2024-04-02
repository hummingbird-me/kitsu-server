class AddAppleIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :apple_id, :string, limit: 255
    add_index :users, :apple_id, unique: true
  end
end
