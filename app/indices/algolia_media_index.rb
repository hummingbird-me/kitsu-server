class AlgoliaMediaIndex < BaseIndex
  self.index_name = 'media'

  # Titles & description
  attributes :titles, :abbreviated_titles, :canonical_title, :description

  # Properties of the media
  attributes :age_rating, :subtype, :season, :year, :season_year, :interest
  attributes :start_date, :end_date, format: AlgoliaDateFormatter

  # Episode/Chapter count
  attributes :episode_count, :chapter_count, :volume_count
  attributes :episode_length, :total_length, format: SecondsToMinutesFormatter

  # Limit updates to happen less-frequently
  attribute :user_count, frequency: 10
  attribute :favorites_count, frequency: 10
  attribute :average_rating, frequency: 2.5, format: FloatFormatter[2]

  # Display Only
  attribute :slug
  attribute :poster_image, format: ShrineAttachmentValueFormatter

  has_many :categories, as: :title
  has_many :people, as: :name, via: 'castings.person'
  has_many :characters, as: :name, via: 'castings.character'
  has_many :streamers, as: :site_name, via: 'streaming_links.streamer'

  def as_json(*)
    super.tap do |json|
      json['synopsis'] = json.dig('description', 'en')
    end
  end
end
