class AddEditedAtToPostsAndComments < ActiveRecord::Migration
  def change
    add_column :posts, :edited_at, :timestamp
    add_column :comments, :edited_at, :timestamp
  end
end
