class Embedder
  USER_AGENT = 'kitsubot/1.0 (+kitsu.io) facebookexternalhit/1.1 (compatible)'.freeze

  class_attribute :_patterns
  attr_reader :url

  def self.url_matches(pattern)
    define_method(:match?) do
      pattern === url
    end
  end

  def self.version
    self::VERSION
  rescue NameError
    1
  end

  def self.cache_id
    "#{name}/#{version}"
  end

  def initialize(url)
    @url = url
  end

  def as_json(*args)
    to_h.as_json(*args)
  end

  def match?
    false
  end

  def get(url)
    Typhoeus.get(url, headers: { 'User-Agent' => USER_AGENT }, followlocation: true).body
  end
end
