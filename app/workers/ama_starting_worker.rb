class AMAStartingWorker
  include Sidekiq::Worker

  def perform(ama)
    ama.send_ama_notification
  end
end
