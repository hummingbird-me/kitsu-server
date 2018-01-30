class TheTvdbDailyWorker
  include Sidekiq::Worker

  def perform
    TheTvdbService.new(TheTvdbService.currently_airing).import!
  end
end
