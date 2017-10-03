class Stat < ApplicationRecord
  module AmountConsumed
    extend ActiveSupport::Concern

    DEFAULT_STATS = {
      'total_media' => 0,
      'total_progress' => 0,
      'total_time' => 0
    }.freeze

    # Fully regenerate data
    def recalculate!
      entries = user.library_entries.by_kind(media_column).where('progress > 0')
                    .eager_load(media_column)
                    .where.not(media_length => nil)

      # clear stats_data
      self.stats_data = {}
      stats_data['all_time'] = {
        total_media: entries.count, # all anime or manga
        total_progress: entries.sum(:progress), # all episodes or chapters
        total_time: entries.sum(:time_spent) # time spent (anime only)
      }

      save!
    end

    class_methods do
      def increment(user, library_entry, options, updated = false)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}AmountConsumed"
        )

        record.stats_data['all_time'] = DEFAULT_STATS.deep_dup if record.new_record?
        # In case recalculate has not been run this will prevent any errors
        record.stats_data['all_time']['total_media'] ||= 0
        record.stats_data['all_time']['total_progress'] ||= 0
        record.stats_data['all_time']['total_time'] ||= 0

        record.stats_data['all_time']['total_media'] += 1 unless updated
        record.stats_data['all_time']['total_progress'] +=
          progress_difference(options)
        # No way to track time for Manga
        unless media_type == 'Manga'
          record.stats_data['all_time']['total_time'] +=
            progress_to_time(library_entry, progress_difference(options))
        end

        record.save!
      end

      def decrement(user, library_entry, options, updated = false)
        record = user.stats.find_by(type: "Stat::#{media_type}AmountConsumed")
        return unless record

        record.stats_data['all_time']['total_media'] -= 1 unless updated
        record.stats_data['all_time']['total_progress'] -=
          progress_difference(options)
        # No way to track time for Manga
        unless media_type == 'Manga'
          record.stats_data['all_time']['total_time'] -=
            progress_to_time(library_entry, progress_difference(options))
        end

        record.save!
      end

      def progress_difference(options)
        if options[:progress_changed]
          options[:progress] - options[:progress_was]
        else
          options[:progress]
        end
      end

      def progress_to_time(le, progress)
        return 0 if le.anime.episode_length.blank?

        progress * le.anime.episode_length
      end
    end
  end
end
