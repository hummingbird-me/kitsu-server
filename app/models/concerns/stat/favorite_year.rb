class Stat < ApplicationRecord
  module FavoriteYear
    extend ActiveSupport::Concern

    def recalculate!
      years = user.library_entries.eager_load(media_column)
                  .where.not(media_start_date => nil)
                  .group("date_part('year', #{media_start_date})::integer")
                  .count

      self.stats_data = years
      stats_data['total'] = years.values.reduce(:+)

      save!
    end

    class_methods do
      def increment(user, library_entry)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}FavoriteYear"
        )
        # set default to total if it doesn't exist
        record.stats_data['total'] = 0 if record.new_record?

        start_date = library_entry.media.start_date&.year&.to_s
        # if start_date doesn't exist, no need to continue
        return unless start_date
        # check if year exists in object
        record.stats_data[start_date] = 0 unless record.stats_data[start_date]
        # increment year by 1
        record.stats_data[start_date] += 1
        # increment total by 1
        record.stats_data['total'] += 1

        record.save!
      end

      def decrement(user, library_entry)
        record = user.stats.find_by(type: "Stat::#{media_type}FavoriteYear")
        return unless record

        start_date = library_entry.media.start_date&.year&.to_s
        # if start_date doesn't exist, no need to continue
        # this shouldn't ever happen for decrement,
        # but rather safe than sorry
        return unless start_date
        # decrement year by 1
        record.stats_data[start_date] -= 1
        # decrement total by 1
        record.stats_data['total'] -= 1

        record.save!
      end
    end
  end
end
