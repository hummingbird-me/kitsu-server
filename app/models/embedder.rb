class Embedder
  attr_reader :url, :body
  delegate :get, to: :EmbedService

  # @return [Integer] the version number of the Embedder class, used for cache busting
  def self.version
    self::VERSION
  rescue NameError
    2
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
  #
  # {
  #   kind: 'image|video|audio|link',       <-- Required; can also be kind.something (subscope)
  #   title: String,                        <-- Required
  #   description: String,                  <-- Optional
  #   url: String,                          <-- Required; the URL for the link
  #   site: {                               <-- Site Information; Required
  #     name: String,                         <-- Required
  #     url: String                           <-- Optional
  #   },
  #   image: {                              <-- Image or Thumbnail; Optional
  #     url: String,                          <-- Required
  #     type: String,                         <-- Optional
  #     width: Number,                        <-- Optional
  #     height: Number,                       <-- Optional
  #     alt: String                           <-- Optional
  #   },
  #   video: {                              <-- Video Embed; Optional
  #     url: String,                          <-- Required
  #     type: String,                         <-- Required; text/html for iframe, video/* for video
  #     width: Number,                        <-- Optional; Required for iframe
  #     height: Number                        <-- Optional; Required for iframe
  #   },
  #   audio: {                              <-- Audio Embed; Optional
  #     url: String,                          <-- Required
  #     type: String,                         <-- Required; text/html for iframe, audio/* for audio
  #     width: Number,                        <-- Optional; Required for iframe
  #     height: Number                        <-- Optional; Required for iframe
  #   }
  # }
  def as_json(*args)
    to_h.as_json(*args)
  end

  def to_json
    as_json.to_json
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
