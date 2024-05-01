class AMAStartingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def self.perform_async(ama)
    super(ama.to_global_id.to_s)
  end

  def perform(ama)
    ama = GlobalID::Locator.locate(ama)
    ama.send_ama_notification
  end
end
