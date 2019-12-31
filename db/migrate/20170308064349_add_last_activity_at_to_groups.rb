class AddLastActivityAtToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :last_activity_at, :datetime
  end
end
