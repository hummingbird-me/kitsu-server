class YoutubeService
  class Client
    API_PREFIX = 'https://www.googleapis.com/youtube/v3'.freeze
    CHANNEL_URL = Addressable::Template.new(
      "#{API_PREFIX}/channels.list?part=id&mine=true{&query*}"
    ).freeze
    VERIFY_URL = Addressable::Template.new(
      "#{API_PREFIX}/tokeninfo{?query*}"
    ).freeze

    attr_reader :token

    def initialize(token)
      @token = token
    end

    def valid?
      res = Typhoeus.get(VERIFY_URL.expand(query: { access_token: token }))
      data = JSON.parse(res.body)
      res.success? && data.aud == ENV['YOUTUBE_API_KEY']
    end

    def channel_id
      res = Typhoeus.get(CHANNEL_URL.expand(query: { access_token: token }))
      data = JSON.parse(res.body)
      data.id if res.success?
    end

    private

    def api_key
      ENV['YOUTUBE_API_KEY']
    end
  end
end
