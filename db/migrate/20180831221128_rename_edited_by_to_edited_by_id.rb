class RenameEditedByToEditedById < ActiveRecord::Migration[4.2]
  def change
    rename_column :posts, :edited_by, :edited_by_id
  end
end
