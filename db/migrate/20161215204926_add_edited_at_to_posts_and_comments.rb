class AddEditedAtToPostsAndComments < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :edited_at, :timestamp
    add_column :comments, :edited_at, :timestamp
  end
end
