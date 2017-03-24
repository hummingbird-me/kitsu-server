class YoutubeService
  class Subscription
    TOPIC_URL = Addressable::Template.new(
      'https://www.youtube.com/xml/feeds/videos.xml{?channel_id}'
    ).freeze
    CALLBACK_URL = Addressable::Template.new(
      'https://kitsu.io/api/hooks/{?linked_account}'
    ).freeze
    SUBSCRIBE_URL = 'https://pubsubhubbub.appspot.com/subscribe'.freeze

    attr_reader :linked_account

    def initialize(link)
      @linked_account = link
      @linked_account = LinkedAccount.find(link) unless link.respond_to?(:id)
    end

    def subscribe
      post form_for('subscribe')
    end

    def unsubscribe
      post form_for('unsubscribe')
    end

    def topic_url
      TOPIC_URL.expand(channel_id: channel_id).to_s
    end

    def self.hmac(data)
      OpenSSL::HMAC.hexdigest('SHA1', secret, data)
    end

    def self.hmac_matches?(data, expected_hmac)
      ActiveSupport::SecurityUtils.secure_compare(hmac(data), expected_hmac)
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
        'hub.callback' => callback_url,
        'hub.topic' => topic_url,
        'hub.mode' => action,
        'hub.secret' => secret
      }
    end

    def callback_url
      CALLBACK_URL.expand(linked_account: linked_account.id)
    end

    def self.secret
      ENV['YOUTUBE_PUBSUB_SECRET']
    end

    def secret
      self.class.secret
    end

    def channel_id
      linked_account.external_user_id
    end
  end
end
