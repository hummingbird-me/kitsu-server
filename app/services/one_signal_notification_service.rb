class OneSignalNotificationService
  def initialize(user, activity)
    @user = user
    @activity = activity
  end

  def run!
    notification = notify!
    invalid_players = notification.dig('errors', 'invalid_player_ids')
    OneSignalPlayer.where(player_id: invalid_players).delete_all if invalid_players
  end

  private

  def notify!
    platforms = OneSignalPlayer.values_at(*notification.setting.enabled_platforms)
    players = OneSignalPlayer.where(platform: platforms, user: @user)
    return unless players.exists?
    res = OneSignal::Notification.create(params: {
      app_id: app_id,
      include_player_ids: players.pluck(:player_id),
      contents: { en: notification.message }
    })
    JSON.parse(res.body)
  end

  def notification
    @notification ||= Feed::NotificationPresenter.new(@activity, @user)
  end

  def app_id
    ENV['ONE_SIGNAL_APP_ID']
  end

  def api_key
    ENV['ONE_SIGNAL_API_KEY']
  end
end
