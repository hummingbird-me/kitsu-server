class HuluMappingWorker
  include Sidekiq::Worker

  def perform
    HuluMappingService.new(Time.now - 24.hours).sync_series_and_episodes
  end
end
