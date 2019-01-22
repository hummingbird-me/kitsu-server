class RenameChangesToChangeData < ActiveRecord::Migration
  def change
    rename_column :changesets, :changes, :change_data
  end
end
