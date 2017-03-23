class YouTubeSubscription
  TOPIC_URL = Addressable::Template.new(
    'https://www.youtube.com/xml/feeds/videos.xml{?channel_id}'
  ).freeze
  CALLBACK_URL = Addressable::Template.new(
    'https://kitsu.io/api/hook/{?linked_account_id}'
  ).freeze
  SUBSCRIBE_URL = 'https://pubsubhubbub.appspot.com/subscribe'.freeze

  def initialize(linked_account, channel_id)
    @linked_account = LinkedAccount.find(linked_account)
    @channel_id = channel_id
  end

  def subscribe
    post form_for('subscribe')
  end

  def unsubscribe
    post form_for('unsubscribe')
  end

  def valid?
    @linked_account.external_user_id == @channel_id
  end

  private

  def post(form)
    body = URI.encode_www_form(form)
    res = Typhoeus.post(SUBSCRIBE_URL,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: body)

    res.success?
  end

  def form_for(action)
    {
      'hub.callback' => CALLBACK_URL.expand(linked_account: @linked_account.id),
      'hub.topic' => TOPIC_URL.expand(channel_id: @channel_id),
      'hub.mode' => action
    }
  end
end
