class RemoveOneSignalIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :one_signal_id, :string
  end
end
