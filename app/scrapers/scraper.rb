class Scraper
  def initialize(url)
    @url = url
  end

  private

  def http
    @http ||= Faraday.new(url: base_url) do |faraday|
      faraday.request :url_encoded
      faraday.response :parse_html
      faraday.adapter Faraday.default_adapter
    end
  end
end
