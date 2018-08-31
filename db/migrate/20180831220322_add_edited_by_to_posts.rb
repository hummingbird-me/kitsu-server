class AddEditedByToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :edited_by, :integer
  end
end
