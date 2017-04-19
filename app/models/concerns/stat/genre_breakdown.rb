class Stat
  module GenreBreakdown
    extend ActiveSupport::Concern

    # Fully regenrate data
    def recalculate!
      genres = user.library_entries.eager_load(media_column => :genres)
                   .where.not(genres: { slug: nil })
                   .group(:'genres.slug').count

      self.stats_data = genres
      stats_data['total'] = genres.values.reduce(:+)

      save!
    end

    class_methods do
      def increment(user, library_entry)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}GenreBreakdown"
        )
        # set default to total if it doesn't exist
        record.stats_data['total'] = 0 if record.new_record?

        library_entry.media.genres.each do |genre|
          record.stats_data[genre.slug] = 0 unless record.stats_data[genre.slug]

          record.stats_data[genre.slug] += 1
          record.stats_data['total'] += 1
        end

        record.save!
      end

      def decrement(user, library_entry)
        record = user.stats.find_by(type: "Stat::#{media_type}GenreBreakdown")
        return unless record

        library_entry.media.genres.each do |genre|
          next unless record.stats_data[genre.slug]

          record.stats_data[genre.slug] -= 1
          record.stats_data['total'] -= 1
        end

        record.save!
      end
    end
  end
end
