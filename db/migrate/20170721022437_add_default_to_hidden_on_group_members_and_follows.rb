class AddDefaultToHiddenOnGroupMembersAndFollows < ActiveRecord::Migration
  def change
    change_column_default :group_members, :hidden, true
    change_column_null :group_members, :hidden, false
    change_column_default :follows, :hidden, true
    change_column_null :follows, :hidden, false
  end
end
