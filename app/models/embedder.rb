class Embedder
  attr_reader :url, :body
  delegate :get, to: :EmbedService

  # @return [Integer] the version number of the Embedder class, used for cache busting
  def self.version
    self::VERSION
  rescue NameError
    1
  end

  # @return [String] the identifier of the Embedder class in our cache
  def self.cache_id
    "#{name}/#{version}"
  end

  # @param url [String] the URL to try to embed
  # @param body [String] the preloaded body of the URL we want to embed
  def initialize(url, body = nil)
    @url = url
    @body = body || get(url)
  end

  # @return [#to_json] the JSON-serializable embed data
  def as_json(*args)
    to_h.as_json(*args)
  end

  # @return [Boolean] whether the Embedder matches the given URL
  def match?
    false
  end

  private

  # @return [Nokogiri::HTML] the DOM of the page that we want to embed
  def html
    @html ||= Nokogiri::HTML(body)
  end
end
