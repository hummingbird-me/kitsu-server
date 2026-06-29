class DramaIndex < Chewy::Index
  include MediaCrutches

  index_scope Drama.includes(:genres, :categories)

  crutch(:people) { |coll| DramaIndex.get_people 'Drama', coll.map(&:id) }
  crutch(:characters) { |coll| DramaIndex.get_characters 'Drama', coll.map(&:id) }
  crutch(:streamers) { |coll| DramaIndex.get_streamers 'Drama', coll.map(&:id) }

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
    field :year, type: 'short' # Update this before year 32,000
    field :genres, value: ->(a) { a.genres.map(&:name) }
    field :categories, value: ->(a) { a.categories.map(&:title) }
    field :user_count, type: 'integer'
    # Castings
    field :people, value: ->(a, crutch) { crutch.people[a.id] }
    field :characters, value: ->(a, crutch) { crutch.characters[a.id] }
    # Where to watch
    field :streamers, value: ->(a, crutch) { crutch.streamers[a.id] }
  end
end
