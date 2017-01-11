class MyAnimeListSyncWorker
  include Sidekiq::Worker

  def perform(library_entry_id, method)
    # TODO: make a report per day for what is happening (syncing)
    library_entry = LibraryEntry.find(library_entry_id)
    media = MyAnimeListService.new(library_entry, method)
    media.execute_method
  end
end
