class AMAStartingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(ama)
    ama.send_ama_notification
  end
end
