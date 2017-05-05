# Service to make OneSignal API
class OneSignalNotificationService
  ONE_SIGNAL_URL = 'https://onesignal.com/api'.freeze

  attr_reader :content, :players, :opts

  # Initialize services with GetStream webhook request
  def initialize(content, players, opts: {})
    @content = content
    @players = players.map { |p| p&.one_signal_id }.compact
    @opts = opts
  end

  # Pack JSON request from preconfigured attr
  def request_json
    opts.merge({
      app_id: app_id,
      content: content,
      include_player_ids: players,
    }).to_json
  end

  # Send notification to OneSignal
  def create
    # POST request to one signal server
    res = Typhoeus.post("#{ONE_SIGNAL_URL}/v1/notifications",
        headers: {
          'Content-Type'  => 'application/json;charset=utf-8',
          'Authorization' => "Basic #{api_key}"
        },
        body: request_json)

    # return unless res.success?
    # res = JSON.parse(res.body)
    # return unless res.has_key?('errors')
    # res['errors']
  end

  private

  def app_id
    ENV['ONE_SIGNAL_APP_ID']
  end

  def api_key
    ENV['ONE_SIGNAL_API_KEY']
  end
end