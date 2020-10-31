require 'update_in_batches'

class AddPermissionsToUsers < ActiveRecord::Migration[5.1]
  using UpdateInBatches

  self.disable_ddl_transaction!

  def up
    add_column :users, :permissions, :integer, default: 0
    say_with_time 'Filling permissions column' do
      User.all.update_in_batches(permissions: 0)
    end
    change_column_null :users, :permissions, false, 0
    change_column_default :users, :permissions, 0
  end

  def down
    remove_column :users, :permissions
  end
end
