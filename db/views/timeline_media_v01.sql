SELECT
	media_feeds.media_type,
	media_feeds.media_id,
	fs.story_id,
	fs.bumped_at
FROM (
  SELECT
    'Anime' as media_type,
    id as media_id,
    feed_id
  FROM anime
  UNION ALL
  SELECT
    'Manga' as media_type,
    id as media_id,
    feed_id
  FROM manga
  UNION ALL
  SELECT
    'Drama' as media_type,
    id as media_id,
    feed_id
  FROM dramas
) media_feeds
INNER JOIN feed_stories fs
ON media_feeds.feed_id = fs.feed_id