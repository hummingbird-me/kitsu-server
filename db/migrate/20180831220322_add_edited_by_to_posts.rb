class AddEditedByToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :edited_by, :integer
  end
end
