-- Media Characters with Voice Actors
SELECT
	CONCAT('c', mc.id, 'v', cv.id) AS id,
	mc.media_type,
	mc.media_id,
	cv.person_id,
	mc.character_id,
	CASE cv.locale WHEN 'fr' THEN 'French'
                 WHEN 'he' THEN 'Hebrew'
                 WHEN 'ja_jp' THEN 'Japanese'
                 WHEN 'hu' THEN 'Hungarian'
                 WHEN 'jp' THEN 'Japanese'
                 WHEN 'pt_br' THEN 'Brazilian'
                 WHEN 'ko' THEN 'Korean'
                 WHEN 'it' THEN 'Italian'
                 WHEN 'en' THEN 'English'
                 WHEN 'us' THEN 'English'
                 WHEN 'es' THEN 'Spanish'
                 WHEN 'de' THEN 'German'
                 END AS language,
	(mc.role = 0) as featured,
	ROW_NUMBER() OVER (PARTITION BY mc.media_type, mc.media_id ORDER BY mc.role, mc.id ASC) AS "order",
	'Voice Actor' as role,
	TRUE as voice_actor,
	least(mc.created_at, cv.created_at) AS created_at,
	greatest(mc.updated_at, cv.updated_at) AS updated_at
FROM media_characters mc
INNER JOIN character_voices cv ON mc.id = cv.media_character_id
-- Media Characters without Voice Actors (mostly Manga)
UNION SELECT
	CONCAT('c', mc.id) AS id,
	mc.media_type,
	mc.media_id,
	NULL as person_id,
	mc.character_id,
	NULL AS language,
	(mc.role = 0) as featured,
	ROW_NUMBER() OVER (PARTITION BY mc.media_type, mc.media_id ORDER BY mc.role, mc.id ASC) AS "order",
	NULL as role,
	FALSE as voice_actor,
	mc.created_at,
	mc.updated_at
FROM media_characters mc
LEFT OUTER JOIN character_voices cv ON mc.id = cv.media_character_id
WHERE cv.id IS NULL
-- Media Staff
UNION SELECT
	CONCAT('s', ms.id) AS id,
	ms.media_type,
	ms.media_id,
	ms.person_id,
	NULL as character_id,
	NULL AS language,
  FALSE as featured,
	ROW_NUMBER() OVER (PARTITION BY ms.media_type, ms.media_id ORDER BY ms.id ASC) AS "order",
	ms.role,
	FALSE as voice_actor,
	ms.created_at,
	ms.updated_at
FROM media_staff ms
