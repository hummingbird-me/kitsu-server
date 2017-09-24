class Stat
  class UpdateWorker
    include Sidekiq::Worker

    def perform(kind, user, library_entry_id)
      library_entry = LibraryEntry.find(library_entry_id)
      library_event = LibraryEvent.create_for(:updated, library_entry)

      case kind
      when :anime
        # TODO: Change this before merging PR 201
        Stat::AnimeActivityHistory.increment(user, library_event)
        # special case checking if progress was increased or decreased
        if progress > progress_was
          Stat::AnimeAmountConsumed.increment(user, library_entry, true)
        elsif progress < progress_was
          Stat::AnimeAmountConsumed.decrement(user, library_entry, true)
        end
      when :manga
        # TODO: Change this before merging PR 201
        Stat::MangaActivityHistory.increment(user, library_event)
        # special case checking if progress was increased or decreased
        if progress > progress_was
          Stat::MangaAmountConsumed.increment(user, library_entry, true)
        elsif progress < progress_was
          Stat::MangaAmountConsumed.decrement(user, library_entry, true)
        end
      end
    end
  end
end
