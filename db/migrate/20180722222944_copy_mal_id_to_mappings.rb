class CopyMALIdToMappings < ActiveRecord::Migration[4.2]
  def change
    execute <<-SQL.squish
      INSERT INTO mappings (
        external_site,
        external_id,
        item_id,
        item_type,
        created_at,
        updated_at
      ) SELECT
        'myanimelist/character' AS external_site,
        mal_id AS external_id,
        id AS item_id,
        'Character' AS item_type,
        created_at,
        updated_at
      FROM characters
      WHERE mal_id IS NOT NULL
    SQL

    execute <<-SQL.squish
      INSERT INTO mappings (
        external_site,
        external_id,
        item_id,
        item_type,
        created_at,
        updated_at
      ) SELECT
        'myanimelist/people' AS external_site,
        mal_id AS external_id,
        id AS item_id,
        'Person' AS item_type,
        created_at,
        updated_at
      FROM people
      WHERE mal_id IS NOT NULL
    SQL
  end
end
