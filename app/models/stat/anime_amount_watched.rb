class Stat
  class AnimeAmountWatched < Stat
    # fully regenerate data.
    def recalculate!
      entries = user.library_entries.eager_load(:anime)
                    .where.not('anime.episode_length': nil)

      stats_data['all_time'] = {
        total_anime: entries.count, # all anime
        total_episodes: entries.sum(:progress), # all episodes
        total_time: entries.sum(:time_spent) # time spent
      }

      save!
    end

    def self.increment(user, library_entry)
      record = user.stats.find_or_initialize_by(
        type: 'Stat::AnimeAmountWatched'
      )
      record = record.default_stats if record.new_record?
      record.increment(library_entry)
    end

    def increment(library_entry)
      stats_data['all_time']['total_anime'] += 1
      stats_data['all_time']['total_episodes'] +=
        progress_difference(library_entry)
      stats_data['all_time']['total_time'] +=
        progress_to_time(library_entry, progress_difference(library_entry))

      save!
    end

    def self.decrement(user, library_entry)
      record = user.stats.find_by(type: 'Stat::AnimeAmountWatched')
      # TODO: do we want to raise or return?
      raise "Stat doesn't exist" unless record
      record.decrement(library_entry)
    end

    def decrement(library_entry)
      stats_data['all_time']['total_anime'] -= 1
      stats_data['all_time']['total_episodes'] -= library_entry.progress
      stats_data['all_time']['total_time'] -=
        progress_to_time(library_entry, library_entry.progress)

      save!
    end

    def default_stats
      stats_data['all_time'] = {
        total_anime: 0,
        total_episodes: 0,
        total_time: 0
      }

      self
    end

    def progress_difference(le)
      le.progress_changed? ? (le.progress - le.progress_was) : le.progress
    end

    def progress_to_time(le, progress)
      return 0 if le.anime.episode_length.nil?

      progress * le.anime.episode_length
    end
  end
end
