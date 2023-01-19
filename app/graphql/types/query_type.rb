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
    Loaders::RecordLoader.for(::Anime, token: context[:token]).load(id)
  end

  field :find_anime_by_slug, Types::Anime, null: true do
    description 'Find a single Anime by Slug'
    argument :slug, String, required: true
  end

  def find_anime_by_slug(slug:)
    Loaders::SlugLoader.for(::Anime, token: context[:token]).load(slug)
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
    service.search(
      title,
      filters: 'kind:anime',
      restrict_searchable_attributes: %w[titles abbreviated_titles canonical_title]
    )
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
    Loaders::RecordLoader.for(::Manga, token: context[:token]).load(id)
  end

  field :find_manga_by_slug, Types::Manga, null: true do
    description 'Find a single Manga by Slug'
    argument :slug, String, required: true
  end

  def find_manga_by_slug(slug:)
    Loaders::SlugLoader.for(::Manga, token: context[:token]).load(slug)
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
    service.search(
      title,
      filters: 'kind:manga',
      restrict_searchable_attributes: %w[titles abbreviated_titles canonical_title]
    )
  end

  field :search_media_by_title, Types::Interface::Media.connection_type, null: false do
    description <<~DESCRIPTION.squish
      Search for any media (Anime, Manga) by title using Algolia.
      If no media_type is supplied, it will search for both.
      The most relevant results will be at the top.
    DESCRIPTION
    argument :title, String, required: true
    argument :media_type, Types::Enum::MediaType,
      required: false,
      prepare: ->(media_type, _) { media_type&.downcase },
      description: <<~DESCRIPTION.squish
        Dynamically choose a specific media_type.
        If left blank, it will return results for both.
      DESCRIPTION
  end

  def search_media_by_title(title:, media_type: nil)
    case media_type
    when 'anime' then search_anime_by_title(title: title)
    when 'manga' then search_manga_by_title(title: title)
    else
      # Both anime and manga will get the same AlgoliaMediaIndex
      service = AlgoliaGraphqlSearchService.new(::Anime, context[:token])
      service.search(
        title,
        restrict_searchable_attributes: %w[titles abbreviated_titles canonical_title]
      )
    end
  end

  field :find_media_by_id_and_type, Types::Interface::Media, null: true do
    description 'Find a single Media by ID and Type'
    argument :id, ID, required: true
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def find_media_by_id_and_type(id:, media_type:)
    case media_type
    when 'anime' then find_anime_by_id(id: id)
    when 'manga' then find_manga_by_id(id: id)
    end
  end

  field :random_media, Types::Interface::Media, null: false do
    description 'Random anime or manga'
    argument :media_type, Types::Enum::MediaType, required: true
    argument :age_ratings, [Types::Enum::AgeRating],
      required: true,
      prepare: ->(age_ratings, context) do
        # No authorization is needed for sfw shows.
        return age_ratings if age_ratings.exclude?('R18')

        if context[:token].blank?
          raise GraphQL::ExecutionError, 'You must be authorized to view R18 media'
        elsif User.current.sfw_filters?
          raise GraphQL::ExecutionError, 'You must have SFW filters turned off'
        end

        age_ratings
      end
  end

  def random_media(media_type:, age_ratings:)
    media_type.safe_constantize
              .where(age_rating: age_ratings)
              .where(Arel.sql('random() <= 0.01'))
              .limit(1).first
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
    Loaders::RecordLoader.for(::User, token: context[:token]).load(id)
  end

  field :find_profile_by_slug, Types::Profile, null: true do
    description 'Find a single User by Slug'
    argument :slug, String, required: true
  end

  def find_profile_by_slug(slug:)
    Loaders::SlugLoader.for(::User, token: context[:token]).load(slug)
  end

  field :search_profile_by_username, Types::Profile.connection_type, null: true do
    description <<~DESCRIPTION.squish
      Search for User by username using Algolia.
      The most relevant results will be at the top.
    DESCRIPTION
    argument :username, String, required: true
  end

  def search_profile_by_username(username:)
    service = AlgoliaGraphqlSearchService.new(::User, context[:token])
    service.search(username, restrict_searchable_attributes: %w[name slug])
  end

  field :find_character_by_id, Types::Character, null: true do
    description 'Find a single Character by ID'
    argument :id, ID, required: true
  end

  def find_character_by_id(id:)
    Loaders::RecordLoader.for(::Character, token: context[:token]).load(id)
  end

  field :find_character_by_slug, Types::Character, null: true do
    description 'Find a single Character by Slug'
    argument :slug, String, required: true
  end

  def find_character_by_slug(slug:)
    Loaders::SlugLoader.for(::Character, token: context[:token]).load(slug)
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
    Loaders::RecordLoader.for(::Category, token: context[:token]).load(id)
  end

  field :find_category_by_slug, Types::Category, null: true do
    description 'Find a single Category by Slug'
    argument :slug, String, required: true
  end

  def find_category_by_slug(slug:)
    Loaders::SlugLoader.for(::Category, token: context[:token]).load(slug)
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
    Loaders::RecordLoader.for(::Person, token: context[:token]).load(id)
  end

  field :find_person_by_slug, Types::Person, null: true do
    description 'Find a single Person by Slug'
    argument :slug, String, required: true
  end

  def find_person_by_slug(slug:)
    Loaders::SlugLoader.for(::Person, token: context[:token]).load(slug)
  end

  field :find_library_entry_by_id, Types::LibraryEntry, null: true do
    description 'Find a single Library Entry by ID'
    argument :id, ID, required: true
  end

  def find_library_entry_by_id(id:)
    Loaders::RecordLoader.for(::LibraryEntry, token: context[:token]).load(id)
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
    Loaders::RecordLoader.for(::LibraryEvent, token: context[:token]).load(id)
  end

  field :find_post_by_id, Types::Post, null: true do
    description 'Find a single Post by ID'
    argument :id, ID, required: true
  end

  def find_post_by_id(id:)
    Loaders::RecordLoader.for(::Post, token: context[:token]).load(id)
  end

  field :find_wiki_submission_by_id, Types::WikiSubmission, null: true do
    description 'Find a single Wiki Submission by ID'
    argument :id, ID, required: true
  end

  def find_wiki_submission_by_id(id:)
    Loaders::RecordLoader.for(::WikiSubmission, token: context[:token]).load(id)
  end

  field :wiki_submissions_by_statuses, Types::WikiSubmission.connection_type, null: true do
    description 'Select all Wiki Submissions that match with a supplied status.'
    argument :sort, Loaders::WikiSubmissionsLoader.sort_argument, required: false
    argument :statuses, [Types::Enum::WikiSubmissionStatus],
      required: false,
      default_value: ::WikiSubmission.statuses.keys,
      description: 'Will return all if not supplied'
  end

  def wiki_submissions_by_statuses(statuses: nil, sort: [{ on: :created_at, direction: :asc }])
    Loaders::WikiSubmissionsLoader.connection_for({
      find_by: :status,
      sort: sort
    }, statuses)
  end

  field :franchises, Types::Franchise.connection_type, null: true do
    description 'All Franchise in the Kitsu database'
  end

  def franchises
    ::Franchise.all
  end

  # field :search_franchise_by_title, Types::Franchise.connection_type, null: true do
  #   description <<~DESCRIPTION.squish
  #     Search for Franchise by title using Algolia.
  #     The most relevant results will be at the top.
  #   DESCRIPTION
  #   argument :title, String, required: true
  # end

  field :reports, Types::Report.connection_type, null: true do
    description 'All Reports in the Kitsu database'
  end

  def reports
    ReportPolicy::Scope.new(context[:token], ::Report).resolve.order(created_at: :desc)
  end

  field :find_report_by_id, Types::Report, null: true do
    description 'Find a single Report by ID'
    argument :id, ID, required: true
  end

  def find_report_by_id(id:)
    Loaders::RecordLoader.for(::Report, token: context[:token]).load(id)
  end

  field :reports_by_status, Types::Report.connection_type, null: true do
    description 'Select all Reports that match with a supplied status.'
    argument :statuses, [Types::Enum::ReportStatus],
      required: false,
      default_value: ::Report.statuses.keys,
      description: 'Will return all if not supplied'
  end

  def reports_by_status(statuses: nil, sort: [{ on: :created_at, direction: :asc }])
    Loaders::ReportsLoader.connection_for({
      find_by: :status,
      sort: sort
    }, statuses)
  end
end
