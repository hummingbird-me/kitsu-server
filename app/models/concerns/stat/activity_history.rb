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

    # both dates will be overwritten, just needed the format
    DEFAULT_STATS = {
      'days' => {},
      'first_event_date' => 5.years.ago,
      'last_update_date' => 5.years.ago,
      'week_high_score' => 0,
      'total_progress' => 0
    }.freeze

    def recalculate!
      self.stats_data = {}

      date_trunc = "date_trunc('day', library_events.created_at)"
      progress_0 = "(changed_data#>>'{progress,0}')::integer"
      progress_1 = "(changed_data#>>'{progress,1}')::integer"
      progress = "(#{progress_1} - #{progress_0})"

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
      stats_data['days'] = generate_missing_days(activity_dates.first[0])
      # Set default for total_progress on top level
      stats_data['total_progress'] = 0
      # Record the date their first library_event was created
      stats_data['first_event_date'] = activity_dates.first[0].to_date
      stats_data['last_update_date'] = activity_dates.last[0].to_date
      # Set the progress and time for each day
      # Set the total_progress from all days
      activity_dates.each do |date, amount, time|
        stats_data['days'][date.year.to_s][date.month.to_s][date.day.to_s] = {
          'total_progress' => amount,
          'total_time' => time
        }
        stats_data['total_progress'] += amount
      end
      # Set the week_high_score from their first library_event date
      stats_data['week_high_score'] = week_high_score(activity_dates.first[0])

      save!
    end

    def generate_missing_days(start_date)
      # not happy about having to use Time.now but I think I have to...
      dates = start_date.to_date..Time.now.to_date

      dates.each_with_object(preset_hash) do |date, h|
        h[date.year.to_s][date.month.to_s][date.day.to_s] = {
          'total_progress' => 0,
          'total_time' => 0
        }
      end
    end

    def find_missing_days(library_event)
      last_update = stats_data['last_update_date'].to_date + 1.day

      if last_update <= library_event.created_at.to_date
        stats_data['days'].deep_merge!(record.generate_missing_days(last_update))
      end

      self
    end

    def preset_hash
      Hash.new { |h, y| h[y] = Hash.new { |h2, m| h2[m] = Hash.new { |h3, d| h3[d] = {} } } }
    end

    # This is a reference inside of the record.stats_data hash
    def day(date)
      stats_data['days'][date.year.to_s][date.month.to_s][date.day.to_s]
    end

    def week_high_score(start_date)
      dates = start_date.to_date..stats_data['last_update_date'].to_date
      current = []
      highest = 0

      dates.each do |date|
        current << day(date)['total_progress']

        highest = current.sum if current.sum > highest
        current.shift if current.count == 7
      end

      highest
    end

    def update_week_high_score(library_event)
      last_week_score = []

      # checks to make sure 7 days worth of data exists.
      if stats_data['first_event_date'].to_date > 6.days.ago(library_event.created_at).to_date
        dates = (stats_data['first_event_date'].to_date..library_event.created_at.to_date)
      else
        six_days_ago = 6.days.ago(stats_data['last_update_date'].to_date).to_date
        dates = (six_days_ago..library_event.created_at.to_date)
      end

      dates.each do |date|
        last_week_score << day(date)['total_progress']
      end
      last_week_score.compact!

      if last_week_score.sum > stats_data['week_high_score']
        stats_data['week_high_score'] = last_week_score.sum
      end

      self
    end

    def check_for_negatives(day)
      day['total_progress'] = 0 if day['total_progress'].negative?
      day['total_time'] = 0 if day['total_time'].negative?
      stats_data['total_progress'] = 0 if stats_data['total_progress'].negative?

      self
    end

    class_methods do
      def increment(user, library_event)
        # return if library_event does not contain progress
        return unless library_event.progress

        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}ActivityHistory"
        )

        if record.new_record?
          record.stats_data = DEFAULT_STATS.deep_dup
          record.stats_data['first_event_date'] = library_event.created_at.to_date

          record.stats_data['days'] = record.generate_missing_days(library_event.created_at.to_date)
        end

        event_created = library_event.created_at.to_date
        # maintain when they last updated
        # the if will prevent any issues with sidekiq failures/retries
        # only update if what is currently in there is less than created_at date
        if record.stats_data['last_update_date'].to_date < event_created
          record.stats_data['last_update_date'] = event_created
        end

        # populate all the days that are missing since their last update
        record = record.find_missing_days(library_event)

        # update the library_event day that is being referenced
        record.day(event_created)['total_progress'] += library_event.progress
        record.day(event_created)['total_time'] += media_time(library_event)
        record.stats_data['total_progress'] += library_event.progress

        # check if any of the 3 above methods are less than 0
        # don't want to deal with any negatives
        record = record.check_for_negatives(record.day(event_created))

        # resetting week_high_score if negative progress
        if library_event.progress.negative?
          first_event_date = record.stats_data['first_event_date']
          record.stats_data['week_high_score'] = record.week_high_score(first_event_date)
        else
          # update week high score
          record = record.update_week_high_score(library_event)
        end

        record.save!
      end

      # this will call the self.media_length in the specific activity
      # ie: AnimeActivityHistory or MangaActivityHistory
      def media_time(le)
        media_length(le) * le.progress
      end

      def decrement(user)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}ActivityHistory"
        )

        record.recalculate!
      end
    end
  end
end
