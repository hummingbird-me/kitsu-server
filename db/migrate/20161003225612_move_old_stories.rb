class MoveOldStories < ActiveRecord::Migration
  class Story < ActiveRecord::Base
    belongs_to :library_entry
    belongs_to :user
    belongs_to :target, polymorphic: true
    belongs_to :group
    has_many :substories
    has_many :notifications, as: :source
  end
  class Substory < ActiveRecord::Base
    belongs_to :user
    belongs_to :target, polymorphic: true
    belongs_to :story
    has_many :notifications, as: :source
    enum substory_type: %i[followed watchlist_status_update comment
                           watched_episode reply]
  end

  def change
    ### Add some columns we forgot (oops)
    # For paranoia
    add_column :posts, :deleted_at, :datetime, index: true
    add_column :comments, :deleted_at, :datetime, index: true
    # For banning
    add_column :comments, :blocked, :boolean, null: false, default: false
    # For groups
    rename_column :posts, :target_id, :target_user_id
    add_column :posts, :target_group_id, :integer, index: true

    ### Text is a reserved word, let's use "content" instead
    rename_column :posts, :text, :content
    rename_column :posts, :text_formatted, :content_formatted
    rename_column :comments, :text, :content
    rename_column :comments, :text_formatted, :content_formatted

    ### Referential Integrity Broke It.
    remove_foreign_key :post_likes, :posts
    remove_foreign_key :post_likes, :users

    # Text: User A --> User B
    execute <<-SQL.squish
      INSERT INTO posts (
        id, target_user_id, user_id, content, content_formatted, created_at,
        updated_at, deleted_at
      ) SELECT
        stories.id,
        stories.user_id AS target_user_id,
        stories.target_id AS user_id,
        coalesce(substories.data->'comment', '') AS content,
        coalesce(substories.data->'formatted_comment', '') AS content_formatted,
        stories.created_at,
        stories.updated_at,
        stories.deleted_at
      FROM substories
      JOIN stories
        ON stories.id = substories.story_id
      WHERE substories.substory_type = #{Substory.substory_types[:comment]}
        AND stories.target_type = 'User'
        AND stories.target_id != stories.user_id
        AND stories.group_id IS NULL
    SQL
    # Text: User A
    execute <<-SQL.squish
      INSERT INTO posts (
        id, user_id, target_group_id, content, content_formatted, created_at,
        updated_at, deleted_at
      ) SELECT
        stories.id,
        stories.user_id,
        stories.group_id AS target_group_id,
        coalesce(substories.data->'comment', '') AS content,
        coalesce(substories.data->'formatted_comment', '') AS content_formatted,
        stories.created_at,
        stories.updated_at,
        stories.deleted_at
      FROM substories
      JOIN stories
        ON stories.id = substories.story_id
      WHERE substories.substory_type = #{Substory.substory_types[:comment]}
        AND stories.target_type = 'User'
        AND stories.target_id = stories.user_id
    SQL

    # Likes
    execute <<-SQL.squish
      INSERT INTO post_likes (post_id, user_id, created_at, updated_at)
      SELECT target_id, user_id, created_at, updated_at
      FROM votes
      WHERE target_type = 'Story'
    SQL

    # And now, fix the counter
    execute "SELECT setval('posts_id_seq', (SELECT MAX(id) FROM posts))"
  end
end
