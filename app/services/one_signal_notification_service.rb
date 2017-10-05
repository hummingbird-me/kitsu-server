class OneSignalNotificationService
  def initialize(user, activity)
    @user = user
    @activity = Feed::Activity.new(activity)
  end

  def notification
    @notification ||= Feed::NotificationPresenter.new(@activity)
  end

  def run!
    setting = notification.setting_for(@user)
    players = OneSignalPlayer.where(platform: setting.enabled_platforms, user: user)
    OneSignal::Notification.create(params: {
      include_player_ids: players.pluck(:player_id),
      contents: { en: notification.message }
    })
  end

  def app_id
    ENV['ONE_SIGNAL_APP_ID']
  end

  def api_key
    ENV['ONE_SIGNAL_API_KEY']
  end
end
