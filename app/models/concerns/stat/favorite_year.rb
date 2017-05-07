class Stat < ApplicationRecord
  module FavoriteYear
    extend ActiveSupport::Concern

    def recalculate!
      years = user.library_entries.eager_load(media_column)
                  .where.not(media_start_date => nil)
                  .group("date_part('year', #{media_start_date})::integer")
                  .count

      stats_data['all_years'] = years
      stats_data['total'] = years.values.reduce(:+)

      save!
    end

    class_methods do
      def increment(user, library_entry)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}FavoriteYear"
        )
        # set default to total and all_years if it doesn't exist
        if record.new_record?
          record.stats_data['total'] = 0
          record.stats_data['all_years'] = {}
        end

        start_date = library_entry.media.start_date&.year&.to_s
        # if start_date doesn't exist, no need to continue
        return unless start_date

        # check if year exists in object
        unless record.stats_data['all_years'][start_date]
          record.stats_data['all_years'][start_date] = 0
        end
        # increment year by 1
        record.stats_data['all_years'][start_date] += 1
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
        # if recalculate! isn't run, this will guard against a start_date
        # not being present and will prevent any errors
        # EXAMPLE: user adds library_entry for anime,
        # then user deletes another anime.
        return unless record.stats_data['all_years'][start_date]
        # decrement year by 1
        record.stats_data['all_years'][start_date] -= 1
        # decrement total by 1
        record.stats_data['total'] -= 1

        record.save!
      end
    end
  end
end
