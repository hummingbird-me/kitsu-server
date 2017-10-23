class Stat
  class LibraryCreateWorker
    include Sidekiq::Worker

    def perform(kind, user, library_entry_id, options)
      library_entry = LibraryEntry.find(library_entry_id)
      # library_event = LibraryEvent.create_for(:added, library_entry)

      case kind
      when :anime
        Stat::AnimeCategoryBreakdown.increment(user, library_entry)
        Stat::AnimeAmountConsumed.increment(user, library_entry, options)
        Stat::AnimeFavoriteYear.increment(user, library_entry)
        # TODO: Change this before merging PR 201
        # Stat::AnimeActivityHistory.increment(user, library_event)
      when :manga
        Stat::MangaCategoryBreakdown.increment(user, library_entry)
        Stat::MangaAmountConsumed.increment(user, library_entry, options)
        Stat::MangaFavoriteYear.increment(user, library_entry)
        # TODO: Change this before merging PR 201
        # Stat::MangaActivityHistory.increment(user, library_event)
      end
    end
  end
end
