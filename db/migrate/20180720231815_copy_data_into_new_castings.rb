class CopyDataIntoNewCastings < ActiveRecord::Migration[4.2]
  def change
    execute <<-SQL.squish
      INSERT INTO media_characters (
        id,
        media_type,
        media_id,
        character_id,
        role,
        created_at,
        updated_at
      ) SELECT
        id,
        'Anime' AS media_type,
        anime_id AS media_id,
        character_id,
        role,
        coalesce(created_at, now()),
        coalesce(updated_at, now())
      FROM anime_characters
    SQL

    # Since we keep the IDs to make the character_voice migration easier, reset the primary key counter
    execute "SELECT setval('media_characters_id_seq', (SELECT MAX(id) FROM media_characters))"

    execute <<-SQL.squish
      INSERT INTO character_voices (
        media_character_id,
        person_id,
        locale,
        licensor_id,
        created_at,
        updated_at
      ) SELECT
        anime_character_id AS media_character_id,
        person_id,
        locale,
        licensor_id,
        coalesce(created_at, now()),
        coalesce(updated_at, now())
      FROM anime_castings
    SQL

    execute <<-SQL.squish
      INSERT INTO media_staff (
        media_type,
        media_id,
        person_id,
        role,
        created_at,
        updated_at
      ) SELECT
        'Anime' AS media_type,
        anime_id AS media_id,
        person_id,
        role,
        coalesce(created_at, now()),
        coalesce(updated_at, now())
      FROM anime_staff
    SQL

    execute <<-SQL.squish
      INSERT INTO media_productions (
        media_type,
        media_id,
        company_id,
        role,
        created_at,
        updated_at
      ) SELECT
        'Anime' AS media_type,
        anime_id AS media_id,
        producer_id AS company_id,
        role,
        coalesce(created_at, now()),
        coalesce(updated_at, now())
      FROM anime_productions
    SQL

    ######## MANGA ########

    execute <<-SQL.squish
      INSERT INTO media_characters (
        media_type,
        media_id,
        character_id,
        role,
        created_at,
        updated_at
      ) SELECT
        'Manga' AS media_type,
        manga_id AS media_id,
        character_id,
        role,
        coalesce(created_at, now()),
        coalesce(updated_at, now())
      FROM manga_characters
    SQL

    execute <<-SQL.squish
      INSERT INTO media_staff (
        media_type,
        media_id,
        person_id,
        role,
        created_at,
        updated_at
      ) SELECT
        'Manga' AS media_type,
        manga_id AS media_id,
        person_id,
        role,
        coalesce(created_at, now()),
        coalesce(updated_at, now())
      FROM manga_staff
    SQL
  end
end
