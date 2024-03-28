class CreateFeedStories < ActiveRecord::Migration[6.1]
  def change
    create_table :feed_stories, primary_key: %i[feed_id story_id] do |t|
      t.bigint :feed_id, null: false
      t.bigint :story_id, null: false
      t.timestamp :bumped_at, null: false

      t.index :bumped_at
    end
  end
end
