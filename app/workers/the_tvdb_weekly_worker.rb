class TheTvdbWeeklyWorker
  include Sidekiq::Worker

  def perform
    TheTvdbService.new(TheTvdbService.missing_thumbnails).import!
  end
end
