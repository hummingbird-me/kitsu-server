class RenameReblogsToReposts < ActiveRecord::Migration[4.2]
  def change
    rename_table :reblogs, :reposts
  end
end
