class OneSignalNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'notifications'

  def perform(notification)
    service = GetstreamWebhookService.new(notification)
    return unless service.feed_target&.one_signal_id
    one_signal_service = OneSignalNotificationService.new(
      service.stringify_activity,
      [service.feed_target.one_signal_id],
      url: service.feed_url,
      chrome_web_icon: 'https://media.kitsu.io/kitsu-256.png'
    )
    one_signal_service.notify_players!
  end
end
