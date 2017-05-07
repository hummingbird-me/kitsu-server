class OneSignalNotificationWorker
  include Sidekiq::Worker

  def perform(notification)
    service = GetstreamWebhookService.new(notification)
    if service.feed_target&.one_signal_id
      one_signal_service = OneSignalNotificationService.new(service.stringify_activity,
        [service.feed_target.one_signal_id])
      one_signal_service.notify_players!
    end
  end
end
