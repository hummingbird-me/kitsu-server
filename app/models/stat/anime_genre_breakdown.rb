class Stat
  class AnimeGenreBreakdown < Stat
    # fully regenerate data
    def recalculate!
      genres = user.library_entries.eager_load(anime: :genres)
                   .where.not(genres: { slug: nil })
                   .group(:'genres.slug').count

      self.stats_data = genres
      stats_data['total'] = genres.values.reduce(:+)

      if new_record?
        save
      else
        update_attribute(:stats_data, stats_data)
      end
    end

    def self.increment_genres(user, genres)
      record = find_or_initialize_by(user: user)

      genres.each do |genre|
        record.stats_data[genre.slug] = 0 unless record.stats_data[genre.slug]
        record.stats_data['total'] = 0 unless record.stats_data['total']

        record.stats_data[genre.slug] += 1
        record.stats_data['total'] += 1
      end

      p record
      record.save
    end

    def self.decrement_genres(user, genres)
      record = find_or_initialize_by(user: user)

      genres.each do |genre|
        record.stats_data[genre.slug] -= 1
        record.stats_data['total'] -= 1
      end
      record.save
    end
  end
end
