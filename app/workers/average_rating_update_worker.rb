class AverageRatingUpdateWorker
  include Sidekiq::Worker

  def perform
    [Anime, Manga, Drama].each(&:update_average_ratings)
  end
end
