class RemoveOneSignalIdFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :one_signal_id, :string
  end
end
