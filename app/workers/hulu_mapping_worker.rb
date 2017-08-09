class HuluMappingWorker
  include Sidekiq::Worker

  def perform
    HuluMappingService.new(Time.now).sync_series_and_episodes
  end
end
