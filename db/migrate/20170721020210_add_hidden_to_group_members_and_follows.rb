class AddHiddenToGroupMembersAndFollows < ActiveRecord::Migration
  def change
    add_column :group_members, :hidden, :boolean
    add_column :follows, :hidden, :boolean
  end
end
