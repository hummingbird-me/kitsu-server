class EmbedService
  EXPIRY = 12.hours
  EMBEDDERS ||= [
    NicoVideoEmbedder,
    OpenGraphEmbedder
  ].freeze

  def initialize(url)
    @url = url
  end

  def as_json
    embedder.as_json
  end

  def to_json
    Rails.cache.fetch(cache_id, expires_in: EXPIRY) do
      embedder.to_json
    end
  end

  def embedder
    @embedder ||= find_embedder
  end

  def find_embedder
    EMBEDDERS.each do |embedder|
      instance = embedder.new(@url)
      return instance if instance.match?
    end
    nil
  end

  def self.cache_id
    # Join all the embedders' cache IDs and digest it
    @cache_id ||= Digest::MD5.hexdigest(EMBEDDERS.map(&:cache_id).join(','))
  end

  def cache_id
    @cache_id ||= "embeds-#{self.class.cache_id}/#{url_digest}"
  end

  def url_digest
    Digest::MD5.hexdigest(@url)
  end

  def match?
    embedder.present?
  end
end
