class CounterCacheResetWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(11, 23) }

  def perform
    CounterCacheResets.media_user_counts
    CounterCacheResets.favorites_count
  end
end
