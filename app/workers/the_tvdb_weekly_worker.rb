class TheTvdbWeeklyWorker
  include Sidekiq::Worker

  def perform
    TheTvdbService.new.import!('weekly')
  end
end
