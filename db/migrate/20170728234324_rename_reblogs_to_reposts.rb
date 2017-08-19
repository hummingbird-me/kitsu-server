class RenameReblogsToReposts < ActiveRecord::Migration
  def change
    rename_table :reblogs, :reposts
  end
end
