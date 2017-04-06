class AddStatusesToGroupInvites < ActiveRecord::Migration
  def change
    add_column :group_invites, :revoked_at, :datetime
    add_column :group_invites, :accepted_at, :datetime
    add_column :group_invites, :declined_at, :datetime
  end
end
