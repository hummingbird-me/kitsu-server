SELECT
	unit_feeds.unit_type,
	unit_feeds.unit_id,
	fs.story_id,
	fs.bumped_at
FROM (
  SELECT
    'Episode' as unit_type,
    id as unit_id,
    feed_id
  FROM episodes
  UNION ALL
  SELECT
    'Chapter' as unit_type,
    id as unit_id,
    feed_id
  FROM chapters
) unit_feeds
INNER JOIN feed_stories fs
ON unit_feeds.feed_id = fs.feed_id