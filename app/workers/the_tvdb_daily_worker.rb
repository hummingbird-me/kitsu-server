class TheTvdbDailyWorker
  include Sidekiq::Worker

  def perform
    TheTvdbService.new(:currently_airing).import!
  end
end
