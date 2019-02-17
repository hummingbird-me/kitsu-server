class Types::QueryType < Types::BaseObject
  field :anime, Types::Anime.connection_type, null: false do
    description 'Anime in the Kitsu database'
    argument :slug, [String], required: false
    argument :id, [String], required: false
  end

  def anime(slug: nil, id: nil)
    if slug
      ::Anime.by_slug(slug)
    elsif id
      ::Anime.find(id)
    else
      ::Anime.all
    end
  end

  field :global_trending, Types::Media.connection_type, null: false do
    description 'List trending media on all of Kitsu'
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

  field :find_profile, Types::Profile, null: true do
    description 'Find a single user in the Kitsu database by slug or ID'
    argument :slug, String, required: false
    argument :id, String, required: false
  end

  def find_profile(slug: nil, id: nil)
    if slug
      ::User.find_by_slug(slug)
    elsif id
      ::User.find_by_id(id)
    end
  end

  field :find_character, Types::Character, null: true do
    description 'Find a Character in the Kitsu database by slug or ID'
    argument :slug, String, required: false
    argument :id, String, required: false
  end

  def find_character(slug: nil, id: nil)
    if slug
      ::Character.find_by_slug(slug)
    elsif id
      ::Character.find_by_id(id)
    end
  end

  field :session, Types::Session,
    null: false,
    description: 'Get your current session info'

  def session
    context[:user] || {}
  end

  field :patrons, Types::User.connection_type, null: false do
    description 'Patrons sorted by a Proprietary Magic Algorithm'
  end

  def patrons
    User.patron.followed_first(context[:user]).order(followers_count: :desc)
  end
end
