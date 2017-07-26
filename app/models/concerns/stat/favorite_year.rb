class Stat < ApplicationRecord
  module FavoriteYear
    extend ActiveSupport::Concern

    DEFAULT_STATS = {
      'total' => 0,
      'total_media' => 0,
      'all_years' => {}
    }.freeze

    def recalculate!
      years = library_entries.group("date_part('year', #{media_start_date})::integer").count

      # clear everything
      self.stats_data = {}
      stats_data['all_years'] = years
      stats_data['total'] = years.values.reduce(:+)
      stats_data['total_media'] = library_entries.count

      save!
    end

    def library_entries
      @le ||= user.library_entries.by_kind(media_column)
                  .where('progress > 0')
                  .eager_load(media_column)
                  .where.not(media_start_date => nil)
    end

    class_methods do
      def increment(user, library_entry)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}FavoriteYear"
        )
        # set default to total and all_years if it doesn't exist
        record.stats_data = DEFAULT_STATS.deep_dup if record.new_record?

        start_date = library_entry.media.start_date&.year&.to_s
        # if start_date doesn't exist, no need to continue
        return unless start_date

        # check if year exists in object
        record.stats_data['all_years'][start_date] ||= 0
        record.stats_data['total'] ||= 0
        record.stats_data['total_media'] ||= 0

        # increment year by 1
        record.stats_data['all_years'][start_date] += 1
        record.stats_data['total'] += 1
        record.stats_data['total_media'] += 1

        record.save!
      end

      def decrement(user, library_entry)
        record = user.stats.find_by(type: "Stat::#{media_type}FavoriteYear")

        return unless record
        return if record.stats_data['total_media'].nil?

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
        record.stats_data['total'] -= 1
        record.stats_data['total_media'] -= 1

        record.save!
      end
    end
  end
end
