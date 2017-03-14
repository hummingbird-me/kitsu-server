class CounterCacheResetWorker
  include Sidekiq::Worker

  def perform
    CounterCacheResets.media_user_counts
    CounterCacheResets.favorite_counts
  end
end
