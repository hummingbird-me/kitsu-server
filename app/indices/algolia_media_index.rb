class AlgoliaMediaIndex < BaseIndex
  self.index_name = 'media'

  # Titles & synopsis
  attributes :titles, :abbreviated_titles, :canonical_title, :synopsis

  # Properties of the media
  attributes :age_rating, :subtype, :season, :year, :season_year, :interest
  attributes :start_date, :end_date, format: AlgoliaDateFormatter

  # Episode/Chapter count
  attributes :episode_count, :episode_length, :chapter_count, :volume_count

  # Limit updates to happen less-frequently
  attribute :user_count, frequency: 10
  attribute :favorites_count, frequency: 10
  attribute :average_rating, frequency: 2.5, format: FloatFormatter[2]

  # Display Only
  attribute :slug
  attribute :poster_image, format: AttachmentValueFormatter

  has_many :categories, as: :title
  has_many :people, as: :name, via: 'castings.person'
  has_many :characters, as: :name, via: 'castings.character'
  has_many :streamers, as: :site_name, via: 'streaming_links.streamer'

  def self.library_search(search_query, filter)
    filter_hash = {
      filters: filter,
      attributesToRetrieve: %w[id kind]
    }
    res = index.search(
      search_query,
      filter_hash
    ).deep_symbolize_keys
    res[:hits]
  end
end
