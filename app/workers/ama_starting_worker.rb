class AMAStartingWorker
  include Sidekiq::Worker

  def perform
    ama.send_ama_notifciation
  end
end
