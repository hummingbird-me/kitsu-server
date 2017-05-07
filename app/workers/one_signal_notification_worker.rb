class OneSignalNotificationWorker
  include Sidekiq::Worker

  def perform(notifications)
    notifications.each do |n|
      service = GetstreamWebhookService.new(n)
      if service.feed_target&.one_signal_id
        OneSignalNotificationService.new(service.stringify_activity,
          [service.feed_target.one_signal_id]).notify_players!
      end
    end
  end
end
