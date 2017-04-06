class CleanUpGroupMembers < ActiveRecord::Migration
  def change
    change_table(:group_members) do |t|
      t.remove :pending
      t.index :rank
    end
  end
end
