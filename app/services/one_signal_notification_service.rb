class OneSignalNotificationService
  class OneSignalError < StandardError; end

  def initialize(user, activity)
    @user = user
    @activity = activity
  end

  def run!
    notification = notify!
    invalid_players = notification[:results].map do |res|
      Raven.breadcrumbs.record(
        data: res,
        category: 'onesignal',
        message: "Notified #{@user.name}"
      )
      if res['errors'].is_a?(Hash)
        res&.dig('errors', 'invalid_player_ids')
      elsif Array.wrap(res['errors']).include?('All included players are not subscribed')
        notification[:player_ids].values.flatten
      else
        Array.wrap(res['errors']).each do |message|
          ex = OneSignalError.new(message)
          Raven.capture_exception(ex)
        end
        []
      end
    end
    invalid_players = invalid_players.flatten.compact
    OneSignalPlayer.where(player_id: invalid_players).delete_all if invalid_players
  end

  private

  def notify!
    return { results: [] } unless notification.setting
    platforms = OneSignalPlayer.platforms.values_at(*notification.setting.enabled_platforms)
    players = OneSignalPlayer.where(platform: platforms, user: @user)
    return { results: [] } unless players.exists?
    # load players, grouping by platform
    player_ids = players.group(:platform).pluck(:platform, Arel.sql('array_agg(player_id)')).to_h
    # Remove duplicate IDs and blanks
    player_ids.transform_values! { |v| v.uniq.reject(&:blank?) }
    # Notify them
    results = player_ids.map { |platform, ids| notify_players(platform, ids) }
    # Return things
    {
      player_ids: player_ids,
      results: results
    }
  end

  def notify_players(platform, players)
    params = params_for(platform).merge(include_player_ids: players)
    res = OneSignal::Notification.create(params: params)
    JSON.parse(res.body)
  end

  def params_for(platform)
    params = {
      app_id: app_id,
      contents: { en: notification.message },
      external_id: external_id_for(platform)
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

  def external_id_for(platform)
    platform = OneSignalPlayer.platforms[platform].to_s(16).upcase
    "#{notification.id[0..-2]}#{platform}"
  end

  def app_id
    ENV['ONE_SIGNAL_APP_ID']
  end

  def api_key
    ENV['ONE_SIGNAL_API_KEY']
  end
end
