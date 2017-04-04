class FixRatingFrequencies < ActiveRecord::Migration
  def change
    mappings = (0.5..5).step(0.5).to_a.map do |rating|
      [rating, (rating * 4) - 1]
    end
    mapping_sql = mappings.map { |(old_rating, new_rating)|
      "'#{new_rating.to_i}', rating_frequencies->'#{old_rating}'"
    }.join(', ')

    [Anime, Manga, Drama].each do |model|
      say_with_time "Migrating #{model.name} frequencies" do
        model.update_all <<-SQL.squish
          rating_frequencies = ARRAY[#{mapping_sql}]::text[]::hstore
        SQL
      end
    end
  end
end
