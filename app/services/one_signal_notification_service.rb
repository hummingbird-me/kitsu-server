# Service to make OneSignal API
class OneSignalNotificationService
  ONE_SIGNAL_URL = 'https://onesignal.com/api'.freeze

  attr_reader :content, :player_ids, :opts

  # Initialize services with GetStream webhook request
  def initialize(content, player_ids, opts = {})
    @content = content
    @player_ids = player_ids
    @opts = opts
  end

  # Pack JSON request from preconfigured attr
  def request_json
    opts.merge(
      app_id: app_id,
      content: content,
      include_player_ids: player_ids
    )
  end

  # Send notification to OneSignal
  def notify_players!
    # POST request to one signal server
    res = Typhoeus.post("#{ONE_SIGNAL_URL}/v1/notifications",
      headers: {
        'Content-Type'  => 'application/json;charset=utf-8',
        'Authorization' => "Basic #{api_key}"
      },
      body: request_json)

    check_and_process_invalids(JSON.parse(res.body)) if res.success?
  end

  private

  def check_and_process_invalids(res)
    return unless res.key?(:errors)
    errors = res[:errors]
    if errors.is_a?(Hash) && errors.key?(:invalid_player_ids)
      # Some one signal player ids are invalid
      players = User.where('one_signal_id IN (?)', errors[:invalid_player_ids])
    else
      players = User.where('one_signal_id IN (?)', player_ids)
    end

    players.update_all(one_signal_id: nil)
  end

  def app_id
    ENV['ONE_SIGNAL_APP_ID']
  end

  def api_key
    ENV['ONE_SIGNAL_API_KEY']
  end
end
