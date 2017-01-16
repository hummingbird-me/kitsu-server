class AverageRatingUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(0, 6, 12, 18) }

  def perform
    [Anime, Manga, Drama].each(&:update_average_ratings)
  end
end
