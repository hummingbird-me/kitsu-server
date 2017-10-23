class RankingUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'later'

  def perform
    [Anime, Manga, Drama].each(&:update_rankings)
  end
end
