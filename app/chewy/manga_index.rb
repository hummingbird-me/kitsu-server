class MangaIndex < Chewy::Index
  include MediaCrutches

  index_scope Manga.includes(:genres, :categories)

  crutch(:people) { |coll| MangaIndex.get_people 'Manga', coll.map(&:id) }
  crutch(:characters) { |coll| MangaIndex.get_characters 'Manga', coll.map(&:id) }

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
    field :chapter_count, type: 'integer' # Manga run for a really long time
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
  end
end
