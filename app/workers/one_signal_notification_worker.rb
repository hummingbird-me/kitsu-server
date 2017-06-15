class OneSignalNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'notifications'

  def perform(notification)
    service = GetstreamWebhookService.new(notification)
    player_ids = service.feed_target&.one_signal_player_ids

    return if player_ids.blank?

    one_signal_service = OneSignalNotificationService.new(
      service.stringify_activity,
      player_ids,
      url: service.feed_url,
      chrome_web_icon: 'https://media.kitsu.io/kitsu-256.png'
    )
    one_signal_service.notify_players!
  end
end
