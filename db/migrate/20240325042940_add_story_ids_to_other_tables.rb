class AddStoryIdsToOtherTables < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :story_id, :bigint, null: true
    add_column :follows, :story_id, :bigint, null: true
    add_column :media_reactions, :story_id, :bigint, null: true
  end
end
