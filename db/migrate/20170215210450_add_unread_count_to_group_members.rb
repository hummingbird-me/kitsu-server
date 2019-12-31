class AddUnreadCountToGroupMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :group_members, :unread_count, :integer, null: false, default: 0
  end
end
