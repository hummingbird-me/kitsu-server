require 'pp'

class Stat < ApplicationRecord
  module ActivityHistory
    extend ActiveSupport::Concern

    # Example of stats:
    # 'days' => {
    #   '2017' => {
    #     '08' => {
    #       '20' => {
    #
    #       }
    #     }
    #   }
    # }

    DEFAULT_STATS = {
      'days' => {},
      'first_event_date' => Time.now.to_date,
      'week_high_score' => 0,
      'total_progress' => 0
    }.freeze

    def recalculate!
      self.stats_data = {}

      date_trunc = "date_trunc('day', library_events.created_at)"
      progress = "((changed_data#>>'{progress,1}')::integer - (changed_data#>>'{progress,0}')::integer)"

      case media_column
      when :anime then watch_time = "sum(#{progress} * anime.episode_length)"
      when :manga then watch_time = 0
      end

      activity_dates = user.library_events.where("changed_data ? 'progress'")
                           .group(date_trunc)
                           .eager_load(media_column)
                           .order("#{date_trunc} ASC")
                           .pluck("#{date_trunc}, sum(#{progress}), #{watch_time}")

      # Set all the days with 0
      stats_data['days'] = pregenerate_all_days(activity_dates.first[0])
      # Set default for total_progress on top level
      stats_data['total_progress'] = 0
      # Record the date their first library_event was created
      stats_data['first_event_date'] = activity_dates.first[0].to_date
      # Set the progress and time for each day
      # Set the total_progress from all days
      activity_dates.each do |date, amount, time|
        stats_data['days'][date.year][date.month][date.day] = {
          'total_progress' => amount,
          'total_time' => time
        }
        stats_data['total_progress'] += amount
      end
      # Set the week_high_score from their first library_event date
      stats_data['week_high_score'] = week_high_score(activity_dates.first[0])

      save!
    end

    def pregenerate_all_days(start_date)
      dates = start_date.to_date..Time.now.to_date

      stats_data['days'] = dates.each_with_object(preset_hash) do |date, h|
        h[date.year][date.month][date.day] = {
          'total_progress' => 0,
          'total_time' => 0
        }
      end
    end

    def preset_hash
      Hash.new { |h, y| h[y] = Hash.new { |h2, m| h2[m] = Hash.new { |h3, d| h3[d] = {} } } }
    end

    def week_high_score(start_date)
      dates = start_date.to_date..Time.now.to_date
      current = []
      highest = 0

      dates.each do |date|
        current << stats_data['days'][date.year][date.month][date.day]['total_progress']

        highest = current.sum if current.sum > highest
        current.shift if current.count == 7
      end

      highest
    end

    class_methods do
      def increment(user, library_event)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}ActivityHistory"
        )

        record.stats_data = DEFAULT_STATS.deep_dup if record.new_record?

        # In case recalculate has not been run this will prevent any errors
        record.stats_data['activity'] ||= []
        record.stats_data['total'] ||= 0

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
