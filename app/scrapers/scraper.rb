require 'faraday/parse_html'

class Scraper
  def initialize(url)
    @url = url
  end

  private

  def http
    @http ||= Faraday.new(url: base_url) do |faraday|
      faraday.request :url_encoded
      faraday.response :follow_redirects
      faraday.use Faraday::ParseHtml
      faraday.adapter Faraday.default_adapter
    end
  end
end
