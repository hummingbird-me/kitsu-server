class EmbedService
  # User-Agent to use for the HTTP request.  We list facebookexternalhit and Twitterbot as
  # compatible to ensure we get served a version with the correct meta tags
  USER_AGENT = <<-UA.squish.freeze
    kitsubot/1.0 (+kitsu.io)
    facebookexternalhit/1.1 (compatible)
    Twitterbot/1.0 (compatible)
  UA
  # How long to wait for a response from the remote server
  EMBED_TIMEOUT = 5.seconds
  # How long to cache the URL data
  EXPIRY = 12.hours
  # List of Embedders to try (matched from top to bottom)
  EMBEDDERS = [
    # Site-specific Solutions
    KitsuEmbedder,      # kitsu.io
    NicoVideoEmbedder,  # nicovideo.jp
    GiphyMediaEmbedder, # media.giphy.com
    # Embed Standards
    OpenGraphEmbedder,   # Facebook OpenGraph data (http://ogp.me/)
    OembedEmbedder,      # oEmbed Data (http://oembed.com/)
    TwitterCardEmbedder, # Twitter Card data (https://dev.twitter.com/cards)
    # Generic Fallback Embeds
    MetaContentEmbedder, # Shitty keyword-stuffed meta tags
    ImageEmbedder,       # Embed direct image links
    GeneralUrlEmbedder   # Just stuff the URL in there
  ].freeze

  # @param url [String] the URL to generate an embed for
  def initialize(url)
    @url = url
  end

  # @see #to_json for a cached string of the JSON
  # @return [#to_json] the object output of the embed
  def as_json(*args)
    Rails.cache.fetch(cache_id, expires_in: EXPIRY) do
      embedder.as_json(*args)
    end
  rescue StandardError => e
    Raven.capture_exception(e)
    {}
  end

  # @return [String] the JSON string for the embedded URL, using cache
  def to_json
    as_json.to_json
  end

  # @return [Boolean] whether or not we found an embedder for the URL
  def match?
    embedder.present?
  end

  # @param url [String] the URL to load
  # @return [String] the body of the link's target
  def self.get(url)
    Timeout.timeout(EMBED_TIMEOUT) do
      req = Typhoeus.get(url, headers: { 'User-Agent' => USER_AGENT }, followlocation: true)
      req.body if req.success?
    end
  end
  delegate :get, to: :class

  # @return [String] a caching ID generated from the list of Embedders
  # @private
  def self.cache_id
    # Join all the embedders' cache IDs and digest it
    @cache_id ||= Digest::MD5.hexdigest(EMBEDDERS.map(&:cache_id).join(','))
  end

  private

  # @return [Embedder] the embedder to handle this URL
  def embedder
    @embedder ||= find_embedder
  end

  # @return [String] a caching ID for the URL
  def cache_id
    @cache_id ||= "embeds-#{self.class.cache_id}/#{url_digest}"
  end

  # @return [String] an MD5 digest of the URL to use as a cache key
  def url_digest
    Digest::MD5.hexdigest(@url)
  end

  # @return [Embedder,nil] an instance of the first Embedder which matches the URL
  def find_embedder
    EMBEDDERS.each do |embedder|
      instance = embedder.new(@url)
      return instance if instance.match?
    end
    nil
  end

  # @return [String,nil] the body of the URL we're trying to embed
  def body
    @body ||= get(@url)
  end
end
