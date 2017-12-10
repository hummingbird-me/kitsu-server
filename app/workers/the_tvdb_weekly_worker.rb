class TheTvdbWeeklyWorker
  include Sidekiq::Worker

  def perform
    TheTvdbService.new(:missing_thumbnails).import!
  end
end
