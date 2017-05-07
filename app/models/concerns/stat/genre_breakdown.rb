class Stat < ApplicationRecord
  module GenreBreakdown
    extend ActiveSupport::Concern

    DEFAULT_STATS = {
      'total' => 0,
      'all_genres' => {}
    }.freeze

    # Fully regenrate data
    def recalculate!
      genres = user.library_entries.eager_load(media_column => :genres)
                   .where.not(genres: { slug: nil })
                   .group(:'genres.slug').count

      # clear stats_data
      self.stats_data = {}
      stats_data['all_genres'] = genres
      stats_data['total'] = genres.values.reduce(:+)

      save!
    end

    class_methods do
      def increment(user, library_entry)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}GenreBreakdown"
        )
        # set default stats if it doesn't exist
        record.stats_data = DEFAULT_STATS.deep_dup if record.new_record?

        library_entry.media.genres.each do |genre|
          record.stats_data['all_genres'][genre.slug] ||= 0

          record.stats_data['all_genres'][genre.slug] += 1
          record.stats_data['total'] += 1
        end

        record.save!
      end

      def decrement(user, library_entry)
        record = user.stats.find_by(type: "Stat::#{media_type}GenreBreakdown")
        return unless record

        library_entry.media.genres.each do |genre|
          next unless record.stats_data['all_genres'][genre.slug]

          record.stats_data['all_genres'][genre.slug] -= 1
          record.stats_data['total'] -= 1
        end

        record.save!
      end
    end
  end
end
