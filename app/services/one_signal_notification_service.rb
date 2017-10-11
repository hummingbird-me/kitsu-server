class OneSignalNotificationService
  def initialize(user, activity)
    @user = user
    @activity = Feed::Activity.new(activity)
  end

  def notification
    @notification ||= Feed::NotificationPresenter.new(@activity, @user)
  end

  def run!
    players = OneSignalPlayer.where(platform: notification.setting.enabled_platforms, user: user)
    OneSignal::Notification.create(params: {
      app_id: app_id,
      include_player_ids: players.pluck(:player_id),
      contents: { en: notification.message }
    })
  end

  private

  def app_id
    ENV['ONE_SIGNAL_APP_ID']
  end

  def api_key
    ENV['ONE_SIGNAL_API_KEY']
  end
end
