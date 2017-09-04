class TheTvdbDailyWorker
  include Sidekiq::Worker

  def perform
    TheTvdbService.new.import!('daily')
  end
end
