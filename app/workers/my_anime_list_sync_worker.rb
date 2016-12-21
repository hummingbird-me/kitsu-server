class MyAnimeListSyncWorker
  include Sidekiq::Worker

  def perform(le, method)
    # TODO: make a report per day for what is happening (syncing)
    media = MyAnimeListService.new(le, method)
    media.execute_method
  end
end
