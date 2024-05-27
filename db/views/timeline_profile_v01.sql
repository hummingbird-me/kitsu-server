SELECT
  users.id AS user_id,
  story_id,
  bumped_at
FROM feed_stories
INNER JOIN users
  ON feed_stories.feed_id = users.feed_id