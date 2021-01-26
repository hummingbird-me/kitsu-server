class ConvertSlugsToCitext < ActiveRecord::Migration[5.1]
  def change
    Anime.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM anime
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |anime|
      Anime.find(anime.id).update(slug: nil)
    end
    change_column :anime, :slug, 'citext USING slug::citext'

    Manga.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM manga
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |manga|
      Manga.find(manga.id).update(slug: nil)
    end
    change_column :manga, :slug, 'citext USING slug::citext'

    Drama.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM dramas
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |drama|
      Drama.find(drama.id).update(slug: nil)
    end
    change_column :dramas, :slug, 'citext USING slug::citext'

    GroupCategory.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM group_categories
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |gc|
      GroupCategory.find(gc.id).update(slug: nil)
    end
    change_column :group_categories, :slug, 'citext USING slug::citext'

    Category.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM categories
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |category|
      Category.find(category.id).update(slug: nil)
    end
    change_column :categories, :slug, 'citext USING slug::citext'

    Genre.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM genres
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |genre|
      Genre.find(genre.id).update(slug: nil)
    end
    change_column :genres, :slug, 'citext USING slug::citext'

    Character.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM characters
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |character|
      Character.find(character.id).update(slug: nil)
    end
    change_column :characters, :slug, 'citext USING slug::citext'

    Person.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM people
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |person|
      Person.find(person.id).update(slug: nil)
    end
    change_column :people, :slug, 'citext USING slug::citext'

    Producer.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM producers
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |producer|
      Producer.find(producer.id).update(slug: nil)
    end
    change_column :producers, :slug, 'citext USING slug::citext'

    Group.find_by_sql("SELECT * FROM (
      SELECT id,
      ROW_NUMBER() OVER(PARTITION BY slug::citext ORDER BY id asc) AS row
      FROM groups
      WHERE slug IS NOT NULL
    ) dups
    WHERE dups.row > 1").each do |group|
      Group.find(group.id).update(slug: nil)
    end
    change_column :groups, :slug, 'citext USING slug::citext'
  end
end
