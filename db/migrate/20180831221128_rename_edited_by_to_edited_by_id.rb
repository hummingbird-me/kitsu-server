class RenameEditedByToEditedById < ActiveRecord::Migration
  def change
    rename_column :posts, :edited_by, :edited_by_id
  end
end
