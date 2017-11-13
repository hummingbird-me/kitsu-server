module HuluImport
  HULU_GUID = ENV['HULU_GUID'].freeze
  HULU_PREFIX = 'https://distribution.hulu.com/api/v1/'.freeze
  HULU_URL = Addressable::Template.new("#{HULU_PREFIX}/{+path*}?guid=#{HULU_GUID}{&query*}").freeze

  # @param path [String] the path of the API request to make
  # @return [String] the URL built for the parameters
  def self.build_url(path, params = {})
    path = path.sub(%r{\A/}, '')
    HULU_URL.expand(path: path, query: params)
  end

  # @param path [String] the path of the API request to make
  # @param params [Hash] the hash of parameters
  # @return [Hash,Array,String] the parsed JSON response
  def self.get(path, params = {})
    url = build_url(path, params)
    response = Net::HTTP.get_response(url)
    JSON.parse(response.body)
  end

  # @return [Streamer] the Streamer row for Hulu
  def self.streamer
    @streamer ||= Streamer.find_by(site_name: 'Hulu')
  end
end
