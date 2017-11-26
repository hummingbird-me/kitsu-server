class Stat
  class LibraryUpdateWorker
    include Sidekiq::Worker

    def perform(kind, user_id, library_entry_id, options)
      return unless user_id.is_a? Integer
      user = User.find(user_id)
      library_entry = LibraryEntry.find(library_entry_id)
      # library_event = LibraryEvent.create_for(:updated, library_entry)

      case kind
      when :anime
        # TODO: Change this before merging PR 201
        # Stat::AnimeActivityHistory.increment(user, library_event)
        # special case checking if progress was increased or decreased
        if options[:progress] > options[:progress_was]
          Stat::AnimeAmountConsumed.increment(user, library_entry, options, true)
        elsif options[:progress] < options[:progress_was]
          Stat::AnimeAmountConsumed.decrement(user, library_entry, options, true)
        end
      when :manga
        # TODO: Change this before merging PR 201
        # Stat::MangaActivityHistory.increment(user, library_event)
        # special case checking if progress was increased or decreased
        if options[:progress] > options[:progress_was]
          Stat::MangaAmountConsumed.increment(user, library_entry, options, true)
        elsif options[:progress] < options[:progress_was]
          Stat::MangaAmountConsumed.decrement(user, library_entry, options, true)
        end
      end
    rescue ActiveRecord::RecordNotFound # rubocop:disable Lint/HandleExceptions
    end
  end
end
