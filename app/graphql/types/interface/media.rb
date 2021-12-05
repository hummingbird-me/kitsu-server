module Types::Interface::Media
  include Types::Interface::Base
  include HasLocalizedField

  orphan_types Types::Manga, Types::Anime
  description 'A media in the Kitsu database'

  # Identifiers
  field :id, ID, null: false

  field :slug, String,
    null: false,
    description: 'The URL-friendly identifier of this media'

  field :type, String,
    null: false,
    description: 'Anime or Manga.'

  # Types::Anime -> Anime
  def type
    self.class.name.split('::').last
  end

  # Localized Titles
  field :titles, Types::TitlesList,
    null: false,
    method: :titles_list,
    description: 'The titles for this media in various locales'

  localized_field :description,
    description: 'A brief (mostly spoiler free) summary or description of the media.'

  field :original_locale, String,
    deprecation_reason: 'Replaced with originCountries and originLanguages',
    null: true,
    description: 'The country in which the media was primarily produced'

  field :origin_countries, [String],
    null: false,
    description: 'The countries in which the media was originally primarily produced'

  field :origin_languages, [String],
    null: false,
    description: 'The languages the media was originally produced in'

  # Age Rating
  field :age_rating, Types::Enum::AgeRating,
    null: true,
    description: 'The recommended minimum age group for this media'

  field :age_rating_guide, String,
    null: true,
    description: 'An explanation of why this received the age rating it did'

  field :sfw, Boolean,
    null: false,
    description: 'Whether the media is Safe-for-Work',
    method: :sfw?

  # Release Information
  field :start_date, Types::Date,
    null: true,
    description: 'The day that this media first released'

  field :end_date, Types::Date,
    null: true,
    description: 'the day that this media made its final release'

  field :next_release, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time of the next release of this media'

  field :status, Types::Enum::ReleaseStatus,
    null: false,
    description: 'The current releasing status of this media'

  field :tba,
    String,
    null: true,
    description: 'Description of when this media is expected to release'

  # User Ratings
  field :average_rating, Float,
    null: true,
    description: 'The average rating of this media amongst all Kitsu users'

  field :user_count, Integer,
    null: true,
    description: 'The number of users with this in their library'

  field :favorites_count, Integer,
    null: true,
    description: 'The number of users with this in their favorites'

  # Images
  field :poster_image, Types::Image,
    method: :poster_image_attacher,
    null: false,
    description: 'The poster image of this media'

  field :banner_image, Types::Image,
    method: :cover_image_attacher,
    null: false,
    description: 'A large banner image for this media'

  field :my_library_entry, Types::LibraryEntry,
    null: true,
    description: 'Your library entry related to this media.'

  def my_library_entry
    if context[:token].blank?
      raise GraphQL::ExecutionError, 'You must be authorized to view your library entry'
    end

    RecordLoader.for(
      LibraryEntry,
      column: :user_id,
      where: { media_id: object.id, media_type: type },
      token: context[:token]
    ).load(User.current.id)
  end

  # Cast
  field :characters, Types::MediaCharacter.connection_type, null: false do
    description 'The characters who starred in this media'
    argument :sort, Loaders::MediaCharactersLoader.sort_argument, required: false
  end

  def characters(sort: [{ on: :created_at, direction: :asc }])
    Loaders::MediaCharactersLoader.connection_for({
      find_by: :media_id,
      sort: sort,
      where: { media_type: type }
    }, object.id)
  end

  field :staff, Types::MediaStaff.connection_type,
    null: false,
    description: 'The staff members who worked on this media'

  def staff
    AssociationLoader.for(object.class, :staff, policy: :media_staff).scope(object)
  end

  field :productions, Types::MediaProduction.connection_type,
    null: false,
    description: 'The companies which helped to produce this media'

  def productions
    AssociationLoader.for(object.class, :productions, policy: :media_production).scope(object)
  end

  field :quotes, Types::Quote.connection_type,
    null: false,
    description: 'A list of quotes from this media'

  def quotes
    AssociationLoader.for(object.class, :quotes).scope(object).then(&:to_a)
  end

  field :categories, Types::Category.connection_type, null: false do
    description 'A list of categories for this media'
    argument :sort, Loaders::MediaCategoriesLoader.sort_argument, required: false
  end

  def categories(sort: [{ on: :created_at, direction: :asc }])
    Loaders::MediaCategoriesLoader.connection_for({
      find_by: :media_id,
      sort: sort,
      where: { media_type: object.class.name }
    }, object.id).then do |categories|
      RecordLoader.for(Category, token: context[:token]).load_many(categories.map(&:category_id))
    end
  end

  field :mappings, Types::Mapping.connection_type,
    null: false,
    description: 'A list of mappings for this media'

  def mappings
    AssociationLoader.for(object.class, :mappings).scope(object)
  end

  field :reactions, Types::MediaReaction.connection_type, null: false do
    description 'A list of reactions for this media'
    argument :sort, Loaders::MediaReactionsLoader.sort_argument, required: false
  end

  def reactions(sort: [{ on: :created_at, direction: :asc }])
    Loaders::MediaReactionsLoader.connection_for({
      find_by: :media_id,
      sort: sort,
      where: { media_type: type }
    }, object.id)
  end

  field :posts, Types::Post.connection_type, null: false do
    description 'All posts that tag this media.'
    argument :sort, Loaders::PostsLoader.sort_argument, required: false
  end

  def posts(sort: [{ on: :created_at, direction: :asc }])
    Loaders::PostsLoader.connection_for({
      find_by: :media_id,
      sort: sort,
      where: { media_type: type }
    }, object.id)
  end

  field :my_wiki_submissions, Types::WikiSubmission.connection_type, null: false do
    description 'A list of your wiki submissions for this media'
    argument :sort, Loaders::WikiSubmissionsLoader.sort_argument, required: false
  end

  def my_wiki_submissions(sort: [{ on: :created_at, direction: :asc }])
    # NOTE: I feel like we want to have some authorized! method we can just shove in here.
    if context[:token].blank?
      raise GraphQL::ExecutionError, 'You must be authorized to view your wiki submissions'
    end

    Loaders::WikiSubmissionsLoader.connection_for({
      find_by: :user_id,
      sort: sort,
      where: "draft->>'id' = '#{object.id}' AND draft->>'type' = '#{object.class.name}'"
    }, User.current.id)
  end
end
