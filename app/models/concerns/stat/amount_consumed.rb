class Stat < ApplicationRecord
  # A common base for both the anime and manga amount-consumed stats.  In future, as we add more
  # media types, this is gonna be handy.
  module AmountConsumed
    extend ActiveSupport::Concern

    # The default stats_data values, automatically handled by the Stat superclass
    def default_data
      { 'media' => 0, 'units' => 0, 'time' => 0, 'completed' => 0 }
    end

    # Override #stats_data to find the percentile for each stat
    def stats_data
      data = super || default_data
      # Generate percentile data
      if global_stat
        data['percentiles'] = %w[media units time].each_with_object({}) do |key, out|
          # Find the first percentile with a value above our own
          percentiles = global_stat.stats_data.dig('percentiles', key)
          next unless percentiles && data[key]

          out[key] = percentiles.find_index { |val| val > data[key] }.to_f / 100
        end

        data['averageDiffs'] = %w[media units time].each_with_object({}) do |key, out|
          # Find the difference from average
          average = global_stat.stats_data.dig('average', key)
          next unless average && data[key] && average.positive? && data[key].positive?

          out[key] = (data[key] - average) / average
        end
      end
      data
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
      stats_data['completed'] = entries.completed_at_least_once.count

      self.recalculated_at = Time.now

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
      stats_data['completed'] -= 1 if entry.completed_at_least_once?

      save_or_recalculate!
    end

    # @param entry [LibraryEntry] an entry that was updated
    # @return [void]
    def on_update(entry)
      diff = LibraryEntryDiff.new(entry)
      stats_data['units'] += diff.progress_diff
      stats_data['units'] += diff.reconsume_diff * (entry.media.send(unit_count) || 0)
      stats_data['time'] += diff.time_diff

      stats_data['completed'] += if diff.became_uncompleted? then -1
                                 elsif diff.became_completed? then +1
                                 else
                                   0
                                 end

      save_or_recalculate!
    end

    private

    def save_or_recalculate!
      if should_recalculate?
        recalculate!
      else
        save!
      end
    end

    def should_recalculate?
      %w[units time media].any? { |k| stats_data[k].negative? }
    end

    # @return [String] the column for the media unit count
    def unit_count
      "#{unit_kind}_count"
    end
  end
end
