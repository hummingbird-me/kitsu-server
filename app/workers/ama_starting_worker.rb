class AMAStartingWorker
  include Sidekiq::Worker

  def perform(ama)
    ama.send_ama_notifciation
  end
end
