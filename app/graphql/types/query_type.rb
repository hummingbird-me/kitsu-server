class Types::QueryType < Types::BaseObject
  field :anime, Types::Anime.connection_type, null: false do
    description 'All Anime in the Kitsu database'
  end

  def anime
    ::Anime.all
  end

  field :find_anime_by_id, Types::Anime, null: false do
    description 'Find a single Anime by ID'
    argument :id, ID, required: true
  end

  def find_anime_by_id(id:)
    ::Anime.find(id)
  end

  field :find_anime_by_slug, Types::Anime, null: false do
    description 'Find a single Anime by Slug'
    argument :slug, String, required: true
  end

  def find_anime_by_slug(slug:)
    ::Anime.find_by(slug: slug)
  end

  field :manga, Types::Manga.connection_type, null: false do
    description 'All Manga in the Kitsu database'
  end

  def manga
    ::Manga.all
  end

  field :find_manga_by_id, Types::Manga, null: false do
    description 'Find a single Manga by ID'
    argument :id, ID, required: true
  end

  def find_manga_by_id(id:)
    ::Manga.find(id)
  end

  field :find_manga_by_slug, Types::Manga, null: false do
    description 'Find a single Manga by Slug'
    argument :slug, String, required: true
  end

  def find_manga_by_slug(slug:)
    ::Manga.find_by(slug: slug)
  end

  field :global_trending, Types::Media.connection_type, null: false do
    description 'List trending media on Kitsu'
    argument :medium, String, required: true
  end

  def global_trending(medium:)
    raise GraphQL::ExecutionError, 'Unknown medium' unless %w[Anime Manga].include?(medium)

    TrendingService.new(medium, token: context[:token]).get(10)
  end

  field :local_trending, Types::Media.connection_type, null: false do
    description 'List trending media within your network'
    argument :medium, String, required: true
  end

  def local_trending(medium:)
    raise GraphQL::ExecutionError, 'Unknown medium' unless %w[Anime Manga].include?(medium)
    return [] unless context[:user]

    TrendingService.new(medium, token: context[:token]).get_network(10)
  end

  field :find_profile_by_id, Types::Profile, null: true do
    description 'Find a single User by ID'
    argument :id, ID, required: true
  end

  def find_profile_by_id(id: nil)
    ::User.find(id)
  end

  field :find_profile_by_slug, Types::Profile, null: true do
    description 'Find a single User by Slug'
    argument :slug, String, required: true
  end

  def find_profile_by_slug(slug:)
    ::User.find_by(slug: slug)
  end

  field :find_character_by_id, Types::Character, null: true do
    description 'Find a single Character by ID'
    argument :id, ID, required: true
  end

  def find_character_by_id(id:)
    ::Character.find(id)
  end

  field :find_character_by_slug, Types::Character, null: true do
    description 'Find a single Character by Slug'
    argument :slug, String, required: true
  end

  def find_character(slug:)
    ::Character.find_by(slug: slug)
  end

  field :session, Types::Session,
    null: false,
    description: 'Get your current session info'

  def session
    context[:user] || {}
  end

  field :patrons, Types::Profile.connection_type, null: false do
    description 'Patrons sorted by a Proprietary Magic Algorithm'
  end

  def patrons
    User.patron.followed_first(context[:user]).order(followers_count: :desc)
  end

  field :find_category_by_id, Types::Category, null: false do
    description 'Find a single Category by ID'
    argument :id, ID, required: true
  end

  def find_category_by_id(id:)
    ::Category.find(id)
  end

  field :find_category_by_slug, Types::Category, null: false do
    description 'Find a single Category by Slug'
    argument :slug, String, required: true
  end

  def find_category_by_slug(slug:)
    ::Category.find_by(slug: slug)
  end
end
