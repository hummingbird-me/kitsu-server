class FillMediaCategories < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL.squish
      INSERT INTO media_categories (media_type, media_id, category_id, created_at, updated_at)
      SELECT
        'Anime' as media_type,
        anime_id as media_id,
        category_id,
        NOW() AS created_at,
        NOW() AS updated_at
      FROM anime_categories
    SQL

    execute <<-SQL.squish
      INSERT INTO media_categories (media_type, media_id, category_id, created_at, updated_at)
      SELECT
        'Manga' as media_type,
        manga_id as media_id,
        category_id,
        NOW() AS created_at,
        NOW() AS updated_at
      FROM categories_manga
    SQL
  end
end
