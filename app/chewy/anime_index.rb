class AnimeIndex < Chewy::Index
  include MediaCrutches

  index_scope Anime.includes(:genres, :categories)

  crutch(:people) { |c| AnimeIndex.get_people 'Anime', c.map(&:id) }
  crutch(:characters) { |c| AnimeIndex.get_characters 'Anime', c.map(&:id) }
  crutch(:streamers) { |c| AnimeIndex.get_streamers 'Anime', c.map(&:id) }

  root date_detection: false do
    include IndexTranslatable

    field :updated_at
    # Titles and freeform text
    translatable_field :titles
    field :abbreviated_titles, type: 'text'
    translatable_field :description
    # Enumerated values
    field :age_rating, :subtype, type: 'keyword'
    # Various Data
    field :episode_count, type: 'short' # Max of 32k or so is reasonable
    field :average_rating, type: 'float'
    field :start_date, :end_date, :created_at, type: 'date'
    field :status, type: 'keyword'
    field :season, type: 'keyword'
    field :year, type: 'short' # Update this before year 32,000
    field :season_year, type: 'short' # ^
    field :genres, value: ->(a) { a.genres.map(&:name) }
    field :categories, value: ->(a) { a.categories.map(&:title) }
    field :user_count, type: 'integer'
    field :favorites_count, type: 'integer'
    field :popularity_rank, type: 'integer'
    # Castings
    field :people, value: ->(a, crutch) { crutch.people[a.id] }
    field :characters, value: ->(a, crutch) { crutch.characters[a.id] }
    # Where to watch
    field :streamers, value: ->(a, crutch) { crutch.streamers[a.id] }
  end
end
