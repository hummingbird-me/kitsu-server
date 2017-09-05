class AddAozoraIdToCommentsAndPosts < ActiveRecord::Migration
  def change
    add_column :comments, :ao_id, :string
    add_column :posts, :ao_id, :string
  end
end
