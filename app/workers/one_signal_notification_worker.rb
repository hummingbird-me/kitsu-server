class OneSignalNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(notification)
    service = GetstreamWebhookService.new(notification)
    player_ids = service.feed_target&.one_signal_player_ids

    return if player_ids.blank?

    stream_activity = service&.activity

    notif_type = NotificationSetting.type_for_activity(
      stream_activity['verb'],
      stream_activity['mentioned_users'] || [],
      service&.feed_id
    )

    filtered_player_ids = OneSignalPlayer.filter_player_ids(player_ids, notif_type)

    one_signal_service = OneSignalNotificationService.new(
      service.stringify_activity,
      filtered_player_ids,
      url: service.feed_url,
      chrome_web_icon: 'https://media.kitsu.io/kitsu-256.png'
    )
    one_signal_service.notify_players!
  end
end
