class AddStatusesToGroupInvites < ActiveRecord::Migration[4.2]
  def change
    add_column :group_invites, :revoked_at, :datetime
    add_column :group_invites, :accepted_at, :datetime
    add_column :group_invites, :declined_at, :datetime
  end
end
