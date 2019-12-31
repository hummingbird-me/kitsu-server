class AddHiddenToGroupMembersAndFollows < ActiveRecord::Migration[4.2]
  def change
    add_column :group_members, :hidden, :boolean
    add_column :follows, :hidden, :boolean
  end
end
