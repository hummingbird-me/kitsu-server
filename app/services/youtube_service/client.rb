class YoutubeService
  class Client
    API_PREFIX = 'https://www.googleapis.com/youtube/v3'.freeze
    CHANNEL_URL = Addressable::Template.new(
      "#{API_PREFIX}/channels.list{?query*}"
    ).freeze
    VERIFY_URL = Addressable::Template.new(
      "#{API_PREFIX}/tokeninfo{?query*}"
    ).freeze

    attr_reader :token

    def initialize(token, api_key:)
      @token = token
      @api_key = api_key
    end

    def valid?
      res = Typhoeus.get(VERIFY_URL.expand(query: { access_token: token }))
      res.success? && JSON.parse(res.body)['aud'] == api_key
    end

    def channel_id
      res = Typhoeus.get(CHANNEL_URL.expand(query: {
        part: 'id',
        mine: 'true',
        access_token: token
      }))
      JSON.parse(res.body)['id'] if res.success?
    end

    private

    def api_key
      @api_key || ENV['YOUTUBE_API_KEY']
    end
  end
end
