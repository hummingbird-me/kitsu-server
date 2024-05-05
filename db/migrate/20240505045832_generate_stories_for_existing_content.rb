class GenerateStoriesForExistingContent < ActiveRecord::Migration[6.1]
  def change
    say_with_time 'Generating stories' do
      execute <<~SQL.gsub(/-\-.*$/, '').squish
        CREATE TEMPORARY TABLE new_stories AS
        -- Post Stories
        SELECT * FROM (
          SELECT
            posts.id AS source_id,
            generate_snowflake (posts.created_at, posts.id) AS snowflake,
            posts.created_at,
            -- Figure out when the post was bumped
            coalesce(
              (
                SELECT created_at
                FROM comments
                WHERE comments.post_id = posts.id
                  AND comments.parent_id IS NULL
                -- Use the id to find the newest one quickly
                ORDER BY id DESC LIMIT 1
              ),
              posts.created_at
            ) AS bumped_at,
            1 AS type,
            jsonb_build_object(
              'post_id', posts.id,
              'is_nsfw', posts.nsfw
            ) AS data,
            coalesce(array_remove(ARRAY[
              (CASE
                WHEN target_group_id IS NOT NULL THEN target_group_j.feed_id
                WHEN target_user_id IS NOT NULL THEN target_user_j.feed_id
                ELSE user_j.feed_id
              END),
              target_anime_j.feed_id,
              target_manga_j.feed_id,
              target_episode_j.feed_id,
              target_chapter_j.feed_id
            ], NULL), '{}') AS feed_ids
          FROM posts
          -- This zany list of joins provides us access to all the feed_ids we need
          LEFT OUTER JOIN users user_j
            ON user_j.id = posts.user_id
          LEFT OUTER JOIN users target_user_j
            ON target_user_j.id = posts.target_user_id
          LEFT OUTER JOIN GROUPS target_group_j
            ON target_group_j.id = posts.target_group_id
          LEFT OUTER JOIN anime target_anime_j
            ON target_anime_j.id = posts.media_id
            AND 'Anime' = posts.media_type
          LEFT OUTER JOIN manga target_manga_j
            ON target_manga_j.id = posts.media_id
            AND 'Manga' = posts.media_type
          LEFT OUTER JOIN episodes target_episode_j
            ON target_episode_j.id = posts.spoiled_unit_id
            AND 'Episode' = posts.spoiled_unit_type
          LEFT OUTER JOIN chapters target_chapter_j
            ON target_chapter_j.id = posts.spoiled_unit_id
            AND 'Chapter' = posts.spoiled_unit_type

          -- Ignore posts marked for deletion, or from a deleted user or target_user
          WHERE posts.deleted_at IS NULL
            AND user_j.id IS NOT NULL
            AND (posts.target_user_id IS NULL OR target_user_j.id IS NOT NULL)
        ) post_stories

        -- Follow stories
        UNION ALL SELECT * FROM (
          SELECT
            follows.id AS source_id,
            generate_snowflake (follows.created_at, follows.id) AS snowflake,
            follows.created_at,
            follows.created_at AS bumped_at,
            2 AS type,
            jsonb_build_object(
              'followed_user_id', follows.followed_id,
              'follower_user_id', follows.follower_id
            ) AS data,
            ARRAY[follower.feed_id] AS feed_ids
          FROM follows
          LEFT OUTER JOIN users follower
            ON follower.id = follows.follower_id
          WHERE follows.hidden IS FALSE
            AND follower.id IS NOT NULL
        ) follow_stories

        -- Reaction Stories
        UNION ALL SELECT * FROM (
          SELECT
            media_reactions.id AS source_id,
            generate_snowflake (media_reactions.created_at, media_reactions.id) AS snowflake,
            media_reactions.created_at,
            media_reactions.created_at AS bumped_at,
            3 AS type,
            jsonb_build_object(
              'media_reaction_id', media_reactions.id,
              'is_nsfw', (
                CASE coalesce(anime.age_rating, manga.age_rating)
                WHEN 3 THEN TRUE
                ELSE FALSE
                END
              )
            ) AS data,
            coalesce(array_remove(ARRAY[
              users.feed_id,
              anime.feed_id,
              manga.feed_id
            ], NULL), '{}') AS feed_ids
          FROM media_reactions
          LEFT OUTER JOIN users
            ON users.id = media_reactions.user_id
          LEFT OUTER JOIN anime
            ON anime.id = media_reactions.media_id
            AND 'Anime' = media_reactions.media_type
          LEFT OUTER JOIN manga
            ON manga.id = media_reactions.media_id
            AND 'Manga' = media_reactions.media_type
          WHERE users.id IS NOT NULL
            AND media_reactions.deleted_at IS NULL
        ) reaction_stories
      SQL

      # We need to look these up efficiently, so we'll make a temp index
      execute 'CREATE INDEX ON new_stories (type, source_id)';
    end

    say_with_time 'Inserting stories' do
      execute <<~SQL.squish
        INSERT INTO stories (id, created_at, bumped_at, type, data)
        SELECT snowflake, created_at, bumped_at, type, data
        FROM new_stories
      SQL
    end

    say_with_time 'Updating content with story_ids' do
      Post.where(story_id: nil).in_batches(of: 1000).update_all(<<~SQL.squish)
        story_id = (
          SELECT snowflake
          FROM new_stories
          WHERE type = 1
            AND source_id = posts.id
        )
      SQL

      Follow.where(story_id: nil).in_batches(of: 1000).update_all(<<~SQL.squish)
        story_id = (
          SELECT snowflake
          FROM new_stories
          WHERE type = 2
            AND source_id = follows.id
        )
      SQL

      MediaReaction.where(story_id: nil).in_batches(of: 1000).update_all(<<~SQL.squish)
        story_id = (
          SELECT snowflake
          FROM new_stories
          WHERE type = 3
            AND source_id = media_reactions.id
        )
      SQL
    end

    say_with_time 'Performing feed fanout' do
      execute <<~SQL.squish
        INSERT INTO feed_stories (feed_id, story_id, bumped_at)
        SELECT unnest(feed_ids) AS feed_id, snowflake AS story_id, bumped_at
        FROM new_stories
      SQL
    end
  end
end
