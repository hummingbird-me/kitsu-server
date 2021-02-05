class Stat < ApplicationRecord
  module ActivityHistory
    extend ActiveSupport::Concern

    def default_data
      {
        'days' => {},
        'first' => user.created_at,
        'last' => user.created_at
      }
    end

    def recalculate!
      self.stats_data = {}

      date_trunc = "date_trunc('day', library_events.created_at)"
      progress_before = "(changed_data#>>'{progress,0}')::integer"
      progress_after = "(changed_data#>>'{progress,1}')::integer"
      progress_diff = "greatest(#{progress_after} - #{progress_before}, 0)"
      time_before = "(changed_data#>>'{time_spent, 0}')::integer"
      time_after = "(changed_data#>>'{time_spent, 1}')::integer"
      time_diff = "greatest(#{time_after} - #{time_before}, 0)"

      activity_groups = user.library_events.where("changed_data ? 'progress'")
                            .group(date_trunc)
                            .by_kind(media_kind)
                            .eager_load(media_kind)
                            .order(Arel.sql("#{date_trunc} ASC"))
                            .pluck(Arel.sql("#{date_trunc}, sum(#{progress_diff}), sum(#{time_diff})"))
      activity_data = activity_groups.each_with_object({}) do |(date, units, time), out|
        out[date.strftime('%F')] = { units: units, time: time }
      end

      stats_data['days'] = activity_data
      unless activity_groups.empty?
        stats_data['first'] = activity_groups.first[0].strftime('%F')
        stats_data['last'] = activity_groups.last[0].strftime('%F')
      end

      save!
    end

    private

    def on_update(entry)
      diff = LibraryEntryDiff.new(entry)
      date = entry.created_at.strftime('%F')
      stats_data['days'][date]['units'] ||= 0
      stats_data['days'][date]['units'] += diff.progress_diff
      stats_data['last'] = date
    end
  end
end
