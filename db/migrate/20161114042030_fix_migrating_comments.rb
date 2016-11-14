class FixMigratingComments < ActiveRecord::Migration
  class Substory < ActiveRecord::Base
    belongs_to :user
    belongs_to :target, polymorphic: true
    enum substory_type: {
      followed: 0,
      status_update: 1,
      comment: 2,
      progress: 3,
      reply: 4
    }
  end

  def change
    # Referential integrity is broken
    remove_foreign_key :comments, :users
    remove_foreign_key :comments, :posts

    # Convert substories into comments
    execute <<-SQL.squish
      INSERT INTO comments (
        id, user_id, content, content_formatted, created_at, updated_at,
        deleted_at, post_id
      ) SELECT
        id,
        user_id,
        coalesce(data->'reply', '') AS content,
        coalesce(data->'reply', '') AS content_formatted,
        created_at,
        updated_at,
        deleted_at,
        story_id AS post_id
      FROM substories
      WHERE substory_type = #{Substory.substory_types[:reply]}
    SQL

    # Fix primary key counter
    execute "SELECT setval('comments_id_seq', (SELECT MAX(id) FROM comments))"
  end
end
