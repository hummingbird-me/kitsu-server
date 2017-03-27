class Stat
  class AnimeGenreBreakdown < Stat
    # fully regenerate data
    def recalculate!
      genres = user.library_entries.eager_load(anime: :genres)
                   .where.not(genres: { slug: nil })
                   .group(:'genres.slug').count

      self.stats_data = genres
      stats_data['total'] = genres.values.reduce(:+)

      save_record
    end

    def self.increment(user, genres)
      record = find_or_initialize_by(user: user)
      record = default_stats(record) if record.new_record?
      record.increment(genres)
    end

    def increment(genres)
      genres.each do |genre|
        stats_data[genre.slug] = 0 unless stats_data[genre.slug]

        stats_data[genre.slug] += 1
        stats_data['total'] += 1
      end

      save_record
    end

    def self.decrement(user, genres)
      record = find_by(user: user)
      errors.add(:stat, "Stat doesn't exist, can't go negative.") unless record
      record.decrement(genres)
    end

    def decrement(genres)
      genres.each do |genre|
        next unless stats_data[genre.slug]

        stats_data[genre.slug] -= 1
        stats_data['total'] -= 1
      end

      save_record
    end

    private

    def default_stats(record)
      record.stats_data['total'] = 0
    end
  end
end
