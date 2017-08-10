# Service to make OneSignal API
class OneSignalNotificationService
  class NotifyError < StandardError
    def initialize(res)
      super("Bad OneSignal push
        timeout: #{res.timed_out?}, code: #{res.code}, response: #{res.body}
        request: #{res.req.original_options[:body]}")
    end
  end

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

    raise NotifyError(res) unless res.success?
    check_and_process_invalids(JSON.parse(res.body))
  end

  private

  def check_and_process_invalids(res)
    return unless res.key?(:errors)
    errors = res[:errors]

    invalid_ids = if errors.is_a?(Hash) && errors.key?(:invalid_player_ids)
                    # Some one signal player ids are invalid
                    errors[:invalid_player_ids]
                  else
                    player_ids
                  end
    OneSignalPlayer.where('player_id IN (?)', invalid_ids).destroy_all
  end

  def app_id
    ENV['ONE_SIGNAL_APP_ID']
  end

  def api_key
    ENV['ONE_SIGNAL_API_KEY']
  end
end
