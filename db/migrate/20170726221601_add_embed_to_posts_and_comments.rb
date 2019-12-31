class AddEmbedToPostsAndComments < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :embed, :jsonb
    add_column :comments, :embed, :jsonb
  end
end
