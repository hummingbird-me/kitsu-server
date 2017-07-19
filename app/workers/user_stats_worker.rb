# HACK: will want to try and find a way to abstract this into something nicer.
# Need to find a similarity between these stats.

class UserStatsWorker
  include Sidekiq::Worker

  def perform(action, kind, user, library_entry)
    library_event = LibraryEvent.create_for(action, library_entry) unless action == :destroyed

    case type
    when :added
      add_stats(kind, user, library_entry, library_event)
    when :updated
      update_stats(kind, user, library_entry, library_event)
    when :destroyed
      destroy_stats(kind, user, library_entry)
    end
  end

  def add_stats(kind, user, library_entry, library_event)
    case kind
    when :anime
      Stat::AnimeCategoryBreakdown.increment(user, library_entry)
      Stat::AnimeAmountConsumed.increment(user, library_entry)
      Stat::AnimeFavoriteYear.increment(user, library_entry)
      Stat::AnimeActivityHistory.increment(user, library_event)
    when :manga
      Stat::MangaCategoryBreakdown.increment(user, library_entry)
      Stat::MangaAmountConsumed.increment(user, library_entry)
      Stat::MangaFavoriteYear.increment(user, library_entry)
      Stat::MangaActivityHistory.increment(user, library_event)
    end
  end

  def update_stats(kind, user, library_entry, library_event)
    case kind
    when :anime
      Stat::AnimeActivityHistory.increment(user, library_event)
      # special case checking if progress was increased or decreased
      if progress > progress_was
        Stat::AnimeAmountConsumed.increment(user, library_entry, true)
      else
        Stat::AnimeAmountConsumed.decrement(user, library_entry, true)
      end
    when :manga
      Stat::MangaActivityHistory.increment(user, library_event)
      # special case checking if progress was increased or decreased
      if progress > progress_was
        Stat::MangaAmountConsumed.increment(user, library_entry, true)
      else
        Stat::MangaAmountConsumed.decrement(user, library_entry, true)
      end
    end
  end

  def destroy_stats(kind, user, library_entry)
    case kind
    when :anime
      Stat::AnimeCategoryBreakdown.decrement(user, library_entry)
      Stat::AnimeAmountConsumed.decrement(user, library_entry)
      Stat::AnimeFavoriteYear.decrement(user, library_entry)
      Stat::AnimeActivityHistory.decrement(user, library_entry)
    when :manga
      Stat::MangaCategoryBreakdown.decrement(user, library_entry)
      Stat::MangaAmountConsumed.decrement(user, library_entry)
      Stat::MangaFavoriteYear.decrement(user, library_entry)
      Stat::MangaActivityHistory.decrement(user, library_entry)
    end
  end
end
