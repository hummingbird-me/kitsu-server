SELECT
  followed_feeds.user_id AS user_id,
  feed_stories.story_id,
  feed_stories.bumped_at
FROM (
  -- Group Memberships
  SELECT
    group_members.user_id AS user_id,
    groups.feed_id AS feed_id
  FROM group_members
  INNER JOIN groups ON groups.id = group_members.group_id
  UNION ALL

  -- Follows
  SELECT
    follows.follower_id AS user_id,
    followed.feed_id AS feed_id
  FROM follows
  INNER JOIN users followed ON followed.id = follows.followed_id
) followed_feeds
INNER JOIN feed_stories
  ON feed_stories.feed_id = followed_feeds.feed_id