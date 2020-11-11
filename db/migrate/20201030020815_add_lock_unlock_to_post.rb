class AddLockUnlockToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :locked_by_id, :integer
    add_column :posts, :locked_at, :datetime
    add_column :posts, :locked_reason, :integer
    add_index :posts, :locked_by_id
  end
end
