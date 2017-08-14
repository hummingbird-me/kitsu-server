class AddEmbedToPostsAndComments < ActiveRecord::Migration
  def change
    add_column :posts, :embed, :jsonb
    add_column :comments, :embed, :jsonb
  end
end
