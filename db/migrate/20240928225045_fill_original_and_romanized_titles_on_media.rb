class FillOriginalAndRomanizedTitlesOnMedia < ActiveRecord::Migration[6.1]
  def up
    Anime.in_batches(of: 1000).each do |batch|
      batch.update_all(<<~SQL.squish)
        original_title = (
          SELECT * FROM (
            SELECT lower(concat(l, '_', c)) AS locale
            FROM unnest(origin_languages) l
            CROSS JOIN unnest(origin_countries) c
          ) locales
          WHERE titles ? locale
          LIMIT 1
        ),
        romanized_title = (
          CASE WHEN titles ? 'en_cn' THEN 'en_cn'
          WHEN titles ? 'en_kr' THEN 'en_kr'
          WHEN titles ? 'en_jp' THEN 'en_jp'
          ELSE NULL
          END
        )
      SQL
    end

    Manga.in_batches(of: 1000).each do |batch|
      batch.update_all(<<~SQL.squish)
        original_title = (
          SELECT * FROM (
            SELECT lower(concat(l, '_', c)) AS locale
            FROM unnest(origin_languages) l
            CROSS JOIN unnest(origin_countries) c
          ) locales
          WHERE titles ? locale
          LIMIT 1
        ),
        romanized_title = (
          CASE WHEN titles ? 'en_cn' THEN 'en_cn'
          WHEN titles ? 'en_kr' THEN 'en_kr'
          WHEN titles ? 'en_jp' THEN 'en_jp'
          ELSE NULL
          END
        )
      SQL
    end
  end

  def down
    Anime.update_all(original_title: nil, romanized_title: nil)
    Manga.update_all(original_title: nil, romanized_title: nil)
  end
end
