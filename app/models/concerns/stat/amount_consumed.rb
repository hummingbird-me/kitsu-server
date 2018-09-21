class Stat < ApplicationRecord
  # A common base for both the anime and manga amount-consumed stats.  In future, as we add more
  # media types, this is gonna be handy.
  module AmountConsumed
    RECALCULATION_CHANCE = 0.1

    extend ActiveSupport::Concern

    # The default stats_data values, automatically handled by the Stat superclass
    def default_data
      { 'media' => 0, 'units' => 0, 'time' => 0 }
    end

    # Recalculate this entire statistic from scratch
    # @return [self]
    def recalculate!
      entries = user.library_entries.by_kind(media_kind)

      reconsume_units = entries.joins(media_kind)
                               .sum("COALESCE(#{unit_count}, 0) * reconsume_count")

      self.stats_data = {}
      stats_data['media'] = entries.count
      stats_data['units'] = reconsume_units + entries.sum(:progress)
      stats_data['time'] = entries.sum(:time_spent)

      save!
    end

    # @param entry [LibraryEntry] an entry that was created
    # @return [void]
    def on_create(entry)
      stats_data['media'] += 1
      on_update(entry)
    end

    # @param entry [LibraryEntry] an entry that was removed
    # @return [void]
    def on_destroy(entry)
      stats_data['media'] -= 1
      stats_data['units'] -= entry.progress
      if entry.media
        stats_data['units'] -= entry.reconsume_count * (entry.media.send(unit_count) || 0)
      end
      stats_data['time'] -= entry.time_spent

      if should_recalculate?
        recalculate!
      else
        save!
      end
    end

    # @param entry [LibraryEntry] an entry that was updated
    # @return [void]
    def on_update(entry)
      diff = LibraryEntryDiff.new(entry)
      stats_data['units'] += diff.progress_diff
      stats_data['units'] += diff.reconsume_diff * (entry.media.send(unit_count) || 0)
      stats_data['time'] += diff.time_diff

      if should_recalculate?
        recalculate!
      else
        save!
      end
    end

    private

    def should_recalculate?
      rand <= RECALCULATE_CHANCE || %w[units time media].any? { |k| stats_data[k].negative? }
    end

    # @return [String] the column for the media unit count
    def unit_count
      "#{unit_kind}_count"
    end
  end
end
