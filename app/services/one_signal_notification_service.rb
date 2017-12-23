class OneSignalNotificationService
  def initialize(user, activity)
    @user = user
    @activity = activity
  end

  def run!
    notification = notify!
    invalid_players = notification.map { |res| res&.dig('errors', 'invalid_player_ids') }
    invalid_players = invalid_players.flatten.compact
    OneSignalPlayer.where(player_id: invalid_players).delete_all if invalid_players
  end

  private

  def notify!
    return [] unless notification.setting
    platforms = OneSignalPlayer.platforms.values_at(*notification.setting.enabled_platforms)
    players = OneSignalPlayer.where(platform: platforms, user: @user)
    return [] unless players.exists?
    # load players, grouping by platform
    player_ids = players.group(:platform).pluck(:platform, 'array_agg(player_id)').to_h
    # fix platform enum keys
    player_ids.transform_keys! { |k| OneSignalPlayer.platforms.invert[k].to_sym }
    # Remove duplicate IDs and blanks
    player_ids.transform_values! { |v| v.uniq.reject(&:blank?) }
    # Notify them
    player_ids.map { |platform, ids| notify_players(platform, ids) }
  end

  def notify_players(platform, players)
    params = params_for(platform).merge(include_player_ids: players)
    res = OneSignal::Notification.create(params: params)
    JSON.parse(res.body)
  end

  def params_for(platform)
    params = {
      app_id: app_id,
      contents: { en: notification.message }
    }
    case platform
    when :mobile
      params[:ios_badgeType] = 'Increase'
      params[:ios_badgeCount] = 1
      params[:data] = notification.reference
    when :web
      params[:url] = notification.url
    end
    params
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
