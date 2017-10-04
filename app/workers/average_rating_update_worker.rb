class AverageRatingUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'later'

  def perform
    [Anime, Manga, Drama].each(&:update_average_ratings)
  end
end
