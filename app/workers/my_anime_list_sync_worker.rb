class MyAnimeListSyncWorker
  include Sidekiq::Worker

  def perform(library_entry, method)
    # TODO: make a report per day for what is happening (syncing)
    media = MyAnimeListService.new(library_entry, method)
    media.execute_method
  end
end
