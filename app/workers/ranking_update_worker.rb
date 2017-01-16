class RankingUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }

  def perform
    [Anime, Manga, Drama].each(&:update_rankings)
  end
end
