class AddPinnedPostToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :pinned_post
    add_foreign_key :groups, :posts, column: 'pinned_post_id'
  end
end
