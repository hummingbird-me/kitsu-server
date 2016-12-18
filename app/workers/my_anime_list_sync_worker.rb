class MyAnimeListSyncWorker

  include Sidekiq::Worker
  include DataExport::MyAnimeList

  def perform(entry, method)
    # TODO: make a report per day for what is happening (syncing)
    media = MyAnimeList.new(entry, method)
    media.execute_method
  end
end
