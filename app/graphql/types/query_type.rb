class Types::QueryType < GraphQL::Schema::Object
  connection_type_class(Types::BaseConnection)

  field :current_account, Types::Account, null: true do
    description 'Kitsu account details. You must supply an Authorization token in header.'
  end

  def current_account
    User.current
  end

  field :anime, Types::Anime.connection_type, null: false do
    description 'All Anime in the Kitsu database'
  end

  def anime
    ::Anime.all
  end

  field :anime_by_status, Types::Anime.connection_type, null: true do
    description 'All Anime with specific Status'
    argument :status, Types::Enum::ReleaseStatus, required: true
  end

  def anime_by_status(status:)
    ::Anime.public_send(status)
  end

  field :find_anime_by_id, Types::Anime, null: true do
    description 'Find a single Anime by ID'
    argument :id, ID, required: true
  end

  def find_anime_by_id(id:)
    RecordLoader.for(::Anime).load(id)
  end

  field :find_anime_by_slug, Types::Anime, null: true do
    description 'Find a single Anime by Slug'
    argument :slug, String, required: true
  end

  def find_anime_by_slug(slug:)
    RecordLoader.for(::Anime, column: :slug).load(slug)
  end

  field :search_anime_by_title, Types::Anime.connection_type, null: false do
    description <<~DESCRIPTION.squish
      Search for Anime by title using Algolia.
      The most relevant results will be at the top.
    DESCRIPTION
    argument :title, String, required: true
  end

  def search_anime_by_title(title:)
    service = AlgoliaGraphqlSearchService.new(::Anime, context[:token])
    service.search(title, filters: 'kind:anime')
  end

  field :manga, Types::Manga.connection_type, null: false do
    description 'All Manga in the Kitsu database'
  end

  def manga
    ::Manga.all
  end

  field :manga_by_status, Types::Manga.connection_type, null: true do
    description 'All Manga with specific Status'
    argument :status, Types::Enum::ReleaseStatus, required: true
  end

  def manga_by_status(status:)
    ::Manga.public_send(status)
  end

  field :find_manga_by_id, Types::Manga, null: true do
    description 'Find a single Manga by ID'
    argument :id, ID, required: true
  end

  def find_manga_by_id(id:)
    RecordLoader.for(::Manga).load(id)
  end

  field :find_manga_by_slug, Types::Manga, null: true do
    description 'Find a single Manga by Slug'
    argument :slug, String, required: true
  end

  def find_manga_by_slug(slug:)
    RecordLoader.for(::Manga, column: :slug).load(slug)
  end

  field :search_manga_by_title, Types::Manga.connection_type, null: false do
    description <<~DESCRIPTION.squish
      Search for Manga by title using Algolia.
      The most relevant results will be at the top.
    DESCRIPTION
    argument :title, String, required: true
  end

  def search_manga_by_title(title:)
    service = AlgoliaGraphqlSearchService.new(::Manga, context[:token])
    service.search(title, filters: 'kind:manga')
  end

  field :search_media_by_title, Types::Interface::Media.connection_type, null: false do
    description <<~DESCRIPTION.squish
      Search for any media (Anime, Manga) by title using Algolia.
      The most relevant results will be at the top.
    DESCRIPTION
    argument :title, String, required: true
  end

  def search_media_by_title(title:)
    # Both anime and manga will get the same AlgoliaMediaIndex
    service = AlgoliaGraphqlSearchService.new(::Anime, context[:token])
    service.search(title)
  end

  field :global_trending, Types::Interface::Media.connection_type, null: false do
    description 'List trending media on Kitsu'
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def global_trending(media_type:)
    TrendingService.new(media_type.safe_constantize, token: context[:token]).get(10)
  end

  field :local_trending, Types::Interface::Media.connection_type, null: false do
    description 'List trending media within your network'
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def local_trending(media_type:)
    return [] unless context[:user]

    TrendingService.new(media_type.safe_constantize, token: context[:token]).get_network(10)
  end

  field :find_profile_by_id, Types::Profile, null: true do
    description 'Find a single User by ID'
    argument :id, ID, required: true
  end

  def find_profile_by_id(id: nil)
    RecordLoader.for(::User).load(id)
  end

  field :find_profile_by_slug, Types::Profile, null: true do
    description 'Find a single User by Slug'
    argument :slug, String, required: true
  end

  def find_profile_by_slug(slug:)
    RecordLoader.for(::User, column: :slug).load(slug)
  end

  field :find_character_by_id, Types::Character, null: true do
    description 'Find a single Character by ID'
    argument :id, ID, required: true
  end

  def find_character_by_id(id:)
    RecordLoader.for(::Character).load(id)
  end

  field :find_character_by_slug, Types::Character, null: true do
    description 'Find a single Character by Slug'
    argument :slug, String, required: true
  end

  def find_character_by_slug(slug:)
    RecordLoader.for(::Character, column: :slug).load(slug)
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

  field :categories, Types::Category.connection_type, null: true do
    description 'All Categories in the Kitsu Database'
  end

  def categories
    ::Category.all
  end

  field :find_category_by_id, Types::Category, null: true do
    description 'Find a single Category by ID'
    argument :id, ID, required: true
  end

  def find_category_by_id(id:)
    RecordLoader.for(::Category).load(id)
  end

  field :find_category_by_slug, Types::Category, null: true do
    description 'Find a single Category by Slug'
    argument :slug, String, required: true
  end

  def find_category_by_slug(slug:)
    RecordLoader.for(::Category, column: :slug).load(slug)
  end

  field :lookup_mapping, Types::Union::MappingItem, null: true do
    description 'Find a specific Mapping Item by External ID and External Site.'
    argument :external_id, ID, required: true
    argument :external_site, Types::Enum::MappingExternalSite, required: true
  end

  def lookup_mapping(external_id:, external_site:)
    ::Mapping.lookup(external_site, external_id)
  end

  field :find_person_by_id, Types::Person, null: true do
    description 'Find a single Person by ID'
    argument :id, ID, required: true
  end

  def find_person_by_id(id:)
    RecordLoader.for(::Person).load(id)
  end

  field :find_person_by_slug, Types::Person, null: true do
    description 'Find a single Person by Slug'
    argument :slug, String, required: true
  end

  def find_person_by_slug(slug:)
    RecordLoader.for(::Person, column: :slug).load(slug)
  end

  field :find_library_entry_by_id, Types::LibraryEntry, null: true do
    description 'Find a single Library Entry by ID'
    argument :id, ID, required: true
  end

  def find_library_entry_by_id(id:)
    RecordLoader.for(::LibraryEntry).load(id)
  end

  field :library_entries_by_media_type, Types::LibraryEntry.connection_type, null: true do
    description 'List of Library Entries by MediaType'
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def library_entries_by_media_type(media_type:)
    ::LibraryEntry.where(media_type: media_type)
  end

  field :library_entries_by_media, Types::LibraryEntry.connection_type, null: true do
    description 'List of Library Entries by MediaType and MediaId'

    argument :media_type, Types::Enum::MediaType, required: true
    argument :media_id, ID, required: true
  end

  def library_entries_by_media(media_type:, media_id:)
    ::LibraryEntry.where(media_type: media_type, media_id: media_id)
  end

  field :find_library_event_by_id, Types::LibraryEvent, null: true do
    description 'Find a single Library Event by ID'
    argument :id, ID, required: true
  end

  def find_library_event_by_id(id:)
    ::LibraryEvent.find_by(id: id)
  end
end
