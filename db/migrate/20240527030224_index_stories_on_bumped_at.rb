class IndexStoriesOnBumpedAt < ActiveRecord::Migration[6.1]
  def change
    add_index :stories, :bumped_at
  end
end
