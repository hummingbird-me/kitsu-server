class Stat
  class LibraryDestroyWorker
    include Sidekiq::Worker

    def perform(kind, user, library_entry, options)
      case kind
      when :anime
        Stat::AnimeCategoryBreakdown.decrement(user, library_entry)
        Stat::AnimeAmountConsumed.decrement(user, library_entry, options)
        Stat::AnimeFavoriteYear.decrement(user, library_entry)
        # TODO: Change this before merging PR 201
        # Stat::AnimeActivityHistory.decrement(user, library_entry)
      when :manga
        Stat::MangaCategoryBreakdown.decrement(user, library_entry)
        Stat::MangaAmountConsumed.decrement(user, library_entry, options)
        Stat::MangaFavoriteYear.decrement(user, library_entry)
        # TODO: Change this before merging PR 201
        # Stat::MangaActivityHistory.decrement(user, library_entry)
      end
    end
  end
end
