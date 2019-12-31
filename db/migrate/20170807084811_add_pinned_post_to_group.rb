class AddPinnedPostToGroup < ActiveRecord::Migration[4.2]
  def change
    add_reference :groups, :pinned_post
    add_foreign_key :groups, :posts, column: 'pinned_post_id'
  end
end
