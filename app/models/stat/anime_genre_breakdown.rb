class Stat
  class AnimeGenreBreakdown < Stat
    # fully regenerate data
    def recalculate!
      genres = user.library_entries.eager_load(anime: :genres)
                   .where.not(genres: { slug: nil })
                   .group(:'genres.slug').count

      self.stats_data = genres
      stats_data['total'] = genres.values.reduce(:+)

      save!
    end

    def self.increment(user, library_entry)
      record = user.stats.find_or_initialize_by(
        type: 'Stat::AnimeGenreBreakdown'
      )
      # set default to total if it doesn't exist
      record.stats_data['total'] = 0 if record.new_record?
      record.increment(library_entry)
    end

    def increment(library_entry)
      library_entry.media.genres.each do |genre|
        stats_data[genre.slug] = 0 unless stats_data[genre.slug]

        stats_data[genre.slug] += 1
        stats_data['total'] += 1
      end

      save!
    end

    def self.decrement(user, library_entry)
      record = user.stats.find_by(type: 'Stat::AnimeGenreBreakdown')
      return unless record
      record.decrement(library_entry)
    end

    def decrement(library_entry)
      library_entry.media.genres.each do |genre|
        next unless stats_data[genre.slug]

        stats_data[genre.slug] -= 1
        stats_data['total'] -= 1
      end

      save!
    end
  end
end
