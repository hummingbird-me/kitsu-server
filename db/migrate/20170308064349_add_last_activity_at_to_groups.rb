class AddLastActivityAtToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :last_activity_at, :datetime
  end
end
