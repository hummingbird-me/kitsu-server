class RankingUpdateWorker
  include Sidekiq::Worker

  def perform
    [Anime, Manga, Drama].each(&:update_rankings)
  end
end
