class AnimeResource < MediaResource
  include EpisodicResource

  attributes :subtype, :youtube_video_id
  attribute :show_type # DEPRECATED
  attribute :nsfw, delegate: :nsfw?
  has_many :streaming_links
  has_many :anime_productions

  # ElasticSearch hookup
  index MediaIndex::Anime
  query :season, valid: ->(value, _ctx) { Anime::SEASONS.include?(value) }
  query :season_year
  query :streamers, valid: ->(value, _ctx) { Streamer.find_by_name(value) }
  query :age_rating,
    valid: ->(value, _ctx) { Anime.age_ratings.keys.include?(value) }

  def self.updatable_fields(context)
    super - [:nsfw]
  end

  def self.creatable_fields(context)
    super - [:nsfw]
  end
end
