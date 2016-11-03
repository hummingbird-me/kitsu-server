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
    enum substory_type: %i[followed watchlist_status_update comment reply
                           watched_episode]
  end

  def change
    ### Add some columns we forgoet (oops)
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

    # Text: User A --> User B
    execute <<-SQL.squish
      INSERT INTO posts (
        id, target_group_id, user_id, content, content_formatted, created_at,
        updated_at, deleted_at
      ) SELECT
        stories.id,
        stories.user_id AS target_group_id,
        stories.target_id AS user_id,
        coalesce(substories.data->'comment', '') AS content,
        coalesce(substories.data->'formatted_comment', '') AS content_formatted,
        stories.created_at,
        stories.updated_at,
        stories.deleted_at
      FROM stories
      JOIN substories
        ON stories.id = substories.story_id
        AND substories.substory_type = #{Substory.substory_types[:comment]}
      WHERE story_type = 'comment'
        AND stories.target_type = 'User'
    SQL
    # Text: User A
    execute <<-SQL.squish
      INSERT INTO posts (
        id, user_id, content, content_formatted, created_at, updated_at,
        deleted_at
      ) SELECT
        stories.id,
        stories.user_id,
        coalesce(substories.data->'comment', '') AS content,
        coalesce(substories.data->'formatted_comment', '') AS content_formatted,
        stories.created_at,
        stories.updated_at,
        stories.deleted_at
      FROM stories
      JOIN substories
        ON substories.id = substories.story_id
        AND substories.substory_type = #{Substory.substory_types[:comment]}
      WHERE story_type = 'comment'
        AND stories.target_type != 'User'
    SQL

    # Replies
    execute <<-SQL.squish
      INSERT INTO comments (
        id, user_id, content, content_formatted, created_at, updated_at,
        deleted_at, post_id
      ) SELECT
        comment.id,
        comment.user_id,
        coalesce(comment.data->'reply', '') AS content,
        coalesce(comment.data->'reply', '') AS content_formatted,
        comment.created_at,
        comment.updated_at,
        comment.deleted_at,
        post.id AS post_id
      FROM substories comment
      JOIN stories
        ON comment.story_id = stories.id
      JOIN substories post
        ON post.story_id = stories.id
        AND post.substory_type = #{Substory.substory_types[:comment]}
      WHERE comment.substory_type = #{Substory.substory_types[:reply]}
    SQL

    # Likes
    execute <<-SQL.squish
      INSERT INTO post_likes (post_id, user_id, created_at, updated_at)
      SELECT target_id, user_id, created_at, updated_at
      FROM votes
      WHERE target_type = 'Story'
    SQL

    # And now, fix the counters
    %w[comments posts].each do |table|
      execute "SELECT setval('#{table}_id_seq', (SELECT MAX(id) FROM #{table}))"
    end
  end
end
