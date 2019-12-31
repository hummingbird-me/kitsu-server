class CleanUpGroupMembers < ActiveRecord::Migration[4.2]
  def change
    change_table(:group_members) do |t|
      t.remove :pending
      t.index :rank
    end
  end
end
