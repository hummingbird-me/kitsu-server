class Stat < ApplicationRecord
  module ActivityHistory
    extend ActiveSupport::Concern

    DEFAULT_STATS = {
      'total' => 0,
      'activity' => []
    }.freeze

    def recalculate!
      activity = user.library_events.eager_load(media_column)

      self.stats_data = {
        total: activity.count,
        activity: activity # collection of events
      }

      save!
    end

    class_methods do
      def increment(user, library_event)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}ActivityHistory"
        )

        record.stats_data = DEFAULT_STATS.deep_dup if record.new_record?
        # add 1 to total
        record.stats_data['total'] += 1
        # push library_event into activity array
        record.stats_data['activity'].push(library_event)

        record.save!
      end

      def decrement(user, library_entry)
        record = user.stats.find_by(type: "Stat::#{media_type}ActivityHistory")
        return unless record

        record.stats_data['activity'].delete_if do |library_event|
          # skip events of the library_entry not deleted
          next unless library_event['library_entry_id'] == library_entry.id
          # decrease total by 1
          record.stats_data['total'] -= 1
          # remove event from array (automatic, delete_if)
        end

        record.save!
      end
    end
  end
end
