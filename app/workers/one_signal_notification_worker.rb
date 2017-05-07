class OneSignalNotificationWorker
  include Sidekiq::Worker

  def perform(notification)
    service = GetstreamWebhookService.new(notification)
    return unless service.feed_target&.one_signal_id
    one_signal_service = OneSignalNotificationService.new(
      service.stringify_activity,
      [service.feed_target.one_signal_id],
      url: service.feed_url
    )
    # TODO: Add 'chrome_web_icon:' url to show
    # awesome kitsu icon in the notification.
    one_signal_service.notify_players!
  end
end
