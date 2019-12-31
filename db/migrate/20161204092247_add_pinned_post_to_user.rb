class AddPinnedPostToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :pinned_post
    add_foreign_key :users, :posts, column: 'pinned_post_id'
  end
end
