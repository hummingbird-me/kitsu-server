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

    def self.increment(user, genres)
      record = user.stats.find_or_initialize_by(
        type: 'Stat::AnimeGenreBreakdown'
      )
      record = record.default_stats if record.new_record?
      record.increment(genres)
    end

    def increment(genres)
      genres.each do |genre|
        stats_data[genre.slug] = 0 unless stats_data[genre.slug]

        stats_data[genre.slug] += 1
        stats_data['total'] += 1
      end

      save!
    end

    def self.decrement(user, genres)
      record = user.stats.find_by(type: 'Stat::AnimeGenreBreakdown')
      # TODO: do we want to raise or return?
      raise "Stat doesn't exist" unless record
      record.decrement(genres)
    end

    def decrement(genres)
      genres.each do |genre|
        # TODO: do we want to skip, or somehow record this error?
        # this should never happen but there is a chance of
        # mistakes happening
        next unless stats_data[genre.slug]

        stats_data[genre.slug] -= 1
        stats_data['total'] -= 1
      end

      save!
    end

    def default_stats
      stats_data['total'] = 0

      self
    end
  end
end
