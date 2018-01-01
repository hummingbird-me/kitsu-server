class Stat < ApplicationRecord
  # A common base for both the anime and manga amount-consumed stats.  In future, as we add more
  # media types, this is gonna be handy.
  module AmountConsumed
    extend ActiveSupport::Concern

    # The default stats_data values, automatically handled by the Stat superclass
    def default_stats
      { 'media' => 0, 'units' => 0, 'time' => 0 }
    end

    # Recalculate this entire statistic from scratch
    # @return [self]
    def recalculate!
      entries = user.library_entries.by_kind(media_kind)

      reconsume_units = entries.joins(media_kind).sum('episode_count * reconsume_count')

      self.stats_data = {}
      stats_data['media'] = entries.count
      stats_data['units'] = reconsume_units + entries.sum(:progress)
      stats_data['time'] = entries.sum(:time_spent)

      save!
    end

    # @param [entry]
    def on_create(entry)
      lock!
      stats_data['media'] += 1
      on_update(entry)
    end

    def on_destroy(entry)
      stats_data['media'] -= 1
      on_update(entry)
    end

    def on_update(entry)
      diff = LibraryEntryDiff.new(entry)
      stats_data['units'] += diff.progress_diff
      stats_data['units'] += diff.reconsume_diff * entry.media.episode_count
      stats_data['time'] += diff.time_diff
      save!
    end
  end
end
