SELECT
  1 AS feed_id,
  stories.id AS story_id,
  stories.bumped_at AS bumped_at
FROM
  stories
LEFT OUTER JOIN posts
  ON posts.id = (data->>'post_id')::integer
WHERE posts.target_user_id IS NULL
  AND posts.target_group_id IS NULL
  AND stories.type IN (1, 3)