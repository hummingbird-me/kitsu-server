module ImgixPurgeService
  API_KEY = ENV['IMGIX_API_KEY']
  API_HOST = 'https://api.imgix.com/'
  PURGE_ENDPOINT = "#{API_HOST}v2/image/purger".freeze

  module_function

  def purge(url)
    url = url.sub('media.kitsu.io', 'kitsu.imgix.net')
    http.post(PURGE_ENDPOINT, url: url)
  end

  def http
    @http ||= Faraday.new(url: 'https://api.imgix.com') do |faraday|
      faraday.request :url_encoded
      faraday.request :basic_auth, API_KEY, ''
      faraday.adapter Faraday.default_adapter
    end
  end
end
