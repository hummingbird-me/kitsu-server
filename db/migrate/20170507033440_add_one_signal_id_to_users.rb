class AddOneSignalIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :one_signal_id, :string
    add_index :users, :one_signal_id
  end
end
