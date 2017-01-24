class RankingUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(0, 12) }

  def perform
    [Anime, Manga, Drama].each(&:update_rankings)
  end
end
