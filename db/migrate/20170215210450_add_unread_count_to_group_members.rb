class AddUnreadCountToGroupMembers < ActiveRecord::Migration
  def change
    add_column :group_members, :unread_count, :integer, null: false, default: 0
  end
end
