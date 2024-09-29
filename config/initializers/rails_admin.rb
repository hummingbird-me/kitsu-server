require Rails.root.join('lib/rails_admin/config/fields/types/localized_string')
require Rails.root.join('lib/rails_admin/config/fields/types/localized_text')
require Rails.root.join('lib/rails_admin/config/fields/types/string_list')
require Rails.root.join('lib/rails_admin/config/fields/types/flags')
require Rails.root.join('lib/rails_admin/config/fields/types/duration')

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.parent_controller = '::AdminController'
  config.current_user_method(&:current_user)

  config.authorize_with :pundit

  config.actions do
    dashboard do                  # mandatory
      statistics false
    end
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    history_show
    show_in_app do
      only %w[Anime Manga Group User]
      controller do
        proc do
          namespace = @abstract_model.table_name.parameterize
          slug = @object.try(:slug) || @object.try(:name)
          redirect_to "https://kitsu.app/#{namespace}/#{slug}"
        end
      end
    end
  end

  # Display canonical_title for label on media
  config.label_methods.unshift(:rails_admin_label)
  config.label_methods += %i[canonical_title site_name]

  # Omitted for security reasons (and Casting is deprecated)
  config.excluded_models += %w[
    LeaderChatMessage LinkedAccount GroupTicketMessage PostLike ProfileLink ReviewLike UserRole Role
    GroupTicket Casting Report CommentLike LinkedAccount::MyAnimeList MediaAttributeVote
    LinkedAccount::YoutubeChannel UserIpAddress Drama AnimeCasting AnimeStaff MangaStaff
    MangaCharacter AnimeProduction DramaCasting DramaCharacter DramaStaff DramaMediaAttribute
    QuoteLike Stat MediaAttribute Hashtag GlobalStat Stat::AnimeActivityHistory
    Stat::AnimeAmountConsumed Stat::AnimeCategoryBreakdown Stat::AnimeFavoriteYear
    Stat::MangaActivityHistory Stat::MangaAmountConsumed Stat::MangaCategoryBreakdown
    Stat::MangaFavoriteYear GlobalStat::AnimeAmountConsumed GlobalStat::MangaAmountConsumed
    ProfileLinkSites MangaMediaAttribute AnimeMediaAttribute DramasMediaAttribute AnimeCharacter
    QuoteLine WikiSubmission WikiSubmissionLog AMA AMASubscriber CommunityRecommendation
    CommunityRecommendationFollow CommunityRecommendationRequest ProfileLinkSite ProMembershipPlan
    ProSubscription ProSubscription::AppleSubscription ProSubscription::StripeSubscription
    ProSubscription::GooglePlaySubscription ProGift GroupCategory
  ]

  # Franchise
  config.model 'Franchise' do
    navigation_label 'Media'
  end
  config.model('Installment') { parent Franchise }
  # Anime
  config.model 'Anime' do
    scope do
      Anime.includes(
        media_relationships: [:destination],
        inverse_media_relationships: [:source],
        episodes: { videos: [:streamer], mappings: [] },
        characters: { character: [], voices: [:person] },
        staff: [:person],
        productions: [:company],
        mappings: [],
        quotes: [:lines, :user]
      )
    end
    navigation_label 'Media'
    list do
      search_by :rails_admin_search
      field :id
      field :slug
      field :poster_image
      field :canonical_title do
        formatted_value do
          bindings[:object].titles[value]
        end
      end
      field :subtype
      field :start_date
      field :end_date
    end
    group :default do
      field :id
      field :titles, :localized_string do
        default_value <<~TITLES
          en:
          en_jp:
          ja_jp:
        TITLES
      end
      field :canonical_title
      field :romanized_title
      field :original_title
      field :abbreviated_titles, :string_list do
        label 'Alternative Titles'
        html_attributes rows: 3, cols: 70
      end
      field :description, :localized_text
      field :origin_countries, :string_list do
        default_value 'JP'
        html_attributes rows: 2
      end
      field :origin_languages, :string_list do
        default_value 'ja'
        html_attributes rows: 2
      end
      field :slug, :string
      field :subtype
      field :poster_image
      field :cover_image
      field :age_rating
      field :age_rating_guide
    end
    group 'Episodes' do
      field :episode_count
      field :episode_count_guess
      field :total_length, :duration
      field :episode_length, :duration
      field :episodes
    end
    group 'Relationships' do
      field :media_relationships
      field :inverse_media_relationships
      field :installments
    end
    group 'External Site Data' do
      field :mappings
      field :streaming_links
    end
    group 'Cast and Crew' do
      field :characters
      field :staff
      field :productions
    end
    include_all_fields
    exclude_fields :library_entries, :favorites,
      :producers, :average_rating, :cover_image_top_offset, :release_schedule,
      :posts, :genres, :anime_staff, :anime_castings, :anime_characters,
      :anime_media_attributes, :media_categories, :reviews, :media_reactions, :franchises,
      :original_locale, :primary_characters
    weight(-20)
  end
  # Manga
  config.model 'Manga' do
    navigation_label 'Media'
    scope do
      Manga.includes(
        media_relationships: [:destination],
        inverse_media_relationships: [:source],
        chapters: [],
        characters: { character: [], voices: [:person] },
        staff: [:person],
        productions: [:company],
        mappings: [],
        quotes: [:lines, :user]
      )
    end
    list do
      search_by :rails_admin_search
      field :id
      field :slug
      field :poster_image
      field :canonical_title do
        formatted_value do
          bindings[:object].titles[value]
        end
      end
      field :subtype
      field :start_date
      field :end_date
    end
    field :id
    field :titles, :localized_string do
      default_value <<~TITLES
        en:
        en_jp:
        ja_jp:
      TITLES
    end
    field :canonical_title
    field :romanized_title
    field :original_title
    field :abbreviated_titles, :string_list do
      label 'Alternative Titles'
      html_attributes rows: 3, cols: 70
    end
    field :description, :localized_text
    field :origin_countries, :string_list do
      default_value 'JP'
      html_attributes rows: 2
    end
    field :origin_languages, :string_list do
      default_value 'ja'
      html_attributes rows: 2
    end
    field :slug
    field :subtype
    field :poster_image
    field :cover_image
    field :age_rating
    field :age_rating_guide
    group 'Chapters' do
      field :chapter_count
      field :volume_count
      field :chapter_count_guess
      field :volumes
      field :chapters
    end
    group 'Relationships' do
      field :media_relationships
      field :inverse_media_relationships
      field :installments
    end
    group 'External Site Data' do
      field :mappings
    end
    group 'Characters and Crew' do
      field :characters
      field :staff
      field :productions
    end
    include_all_fields
    exclude_fields :library_entries, :inverse_media_relationships, :favorites,
      :average_rating, :cover_image_top_offset, :release_schedule, :posts,
      :genres, :manga_characters, :manga_staff, :manga_media_attributes, :reviews, :media_reactions,
      :media_categories, :franchises, :original_locale, :primary_characters
    weight(-15)
  end
  config.model 'Chapter' do
    parent Manga
    fields :id, :manga
    field :titles, :localized_string
    field :description, :localized_text
    fields :canonical_title, :number, :published, :volume_number,
      :length, :thumbnail
    include_all_fields
  end
  config.model 'Volume' do
    parent Manga
  end

  config.model 'MediaCharacter' do
    label 'Media Characters'
    navigation_label 'Media'
    parent Character
  end
  config.model 'MediaStaff' do
    label 'Media Staff'
    navigation_label 'Media'
    parent Person
  end
  config.model 'MediaProduction' do
    label 'Media Producers'
    navigation_label 'Media'
    parent Producer
  end
  config.model 'CharacterVoice' do
    label 'Character Voices'
    navigation_label 'Media'
    parent Character
    field :media_character
    field :person
    field :licensor
    field :locale
  end
  config.model 'Producer' do
    label 'Production Companies'
    navigation_label 'Media'
  end
  config.model 'Person' do
    navigation_label 'Media'
  end
  config.model 'Quote' do
    navigation_label 'Media'
    field :media
    field :user
    field :lines
  end
  config.model 'QuoteLine' do
    visible false
    field :character
    field :quote
    field :order
    field :content
  end
  config.model 'MediaRelationship' do
    navigation_label 'Media'
  end

  # Groups
  config.model 'Group' do
    navigation_label 'Social'
    weight(5)
  end
  config.model('GroupActionLog') { parent Group }
  config.model('GroupBan') { parent Group }
  config.model('GroupCategory') { parent Group }
  config.model('GroupInvite') { parent Group }
  config.model('GroupMember') { parent Group }
  config.model('GroupMemberNote') { parent GroupMember }
  config.model('GroupPermission') { parent GroupMember }
  config.model('GroupNeighbor') { parent Group }
  config.model('GroupReport') { parent Group }
  config.model('GroupTicket') { parent Group }
  config.model('GroupTicketMessage') { parent GroupTicket }

  # Users
  config.model 'User' do
    fields :id, :name, :slug, :email, :about, :avatar, :cover_image
    include_all_fields
    exclude_fields :password_digest, :remember_created_at, :current_sign_in_at,
      :last_sign_in_at, :recommendations_up_to_date, :facebook_id, :twitter_id,
      :mal_username, :life_spent_on_anime, :bio, :ninja_banned, :to_follow,
      :dropbox_token, :dropbox_secret, :last_backup, :stripe_token,
      :stripe_customer_id, :import_status, :import_from, :import_error,
      :profile_completed, :feed_completed, :followers, :following, :comments,
      :posts, :blocks, :last_recommendations_update, :title,
      :library_entries, :library_events, :slug, :permissions
    navigation_label 'Users'
    weight(-10)
  end
  config.model('ListImport') { parent User }
  config.model('Favorite') { parent User }
  config.model('Block') { parent User }
  config.model('Follow') { parent User }
  config.model('LibraryEntry') { parent User }
  config.model('LibraryEntryLog') { visible false }
  config.model('LibraryEvent') { parent User }
  config.model('MediaIgnore') { parent User }
  config.model('PostFollow') { parent User }
  config.model('NotificationSetting') { parent User }
  config.model('OneSignalPlayer') { parent NotificationSetting }
  config.model('CategoryFavorite') { parent User }

  # Feed
  config.model('Post') { navigation_label 'Social' }
  config.model('Comment') { parent Post }
  config.model('Repost') { parent Post }
  config.model('Upload') { parent Post }
  config.model('Wordfilter') do
    weight(-5)
    navigation_label 'Social'
    object_label_method { :pattern }
    field :pattern, :string do
      help <<~HELP.squish.html_safe
        <b>Required.</b> The pattern to trigger this action on.<br /><br />
        <b>If regex is enabled:</b> this is a case-insensitive PCRE (Perl-compatible Regular
        Expression), not wrapped in slashes.<br /><br />
        <b>If regex is <i>not</i> enabled:</b> this is an SQL LIKE expression. In this mode,
        percent sign (%), underscore (_), backslash (\\) have special meaning. Percent sign (%)
        means "any number of any characters" and underscore (_) means "any one character". If you
        want to match an actual percent sign, underscore, or backslash, preface them with a
        backslash (\\) to "escape" them, or ask for help!
      HELP
    end

    field :regex_enabled, :boolean
    field :locations, :flags

    field :action, :enum do
      help <<~HELP.html_safe
        Specifies which action to take when this wordfilter matches:<ul>
        <li><b>Censor</b> - replaces the naughty phrase with "CENSORED"</li>
        <li><b>Report</b> - automatically creates a Report</li>
        <li><b>Hide</b> - hides the content from other users, but allows the poster to see it</li>
        <li><b>Reject</b> - displays an error to the user when they try to submit</li></ul>
      HELP
    end
  end

  config.model('Review') { navigation_label 'Social' }
  config.model('MediaReaction') { navigation_label 'Social' }
  config.model('MediaReactionVote') { parent MediaReaction }

  config.model('StreamingLink') do
    navigation_label 'Media'
    parent Anime
    fields :id, :media, :streamer, :url
    field :subs, :string_list
    field :dubs, :string_list
    include_all_fields
  end

  config.model('Video') { parent Episode }

  config.model 'Mapping' do
    navigation_label 'Media'
    fields :id, :item
    object_label_method { :external_site }
    field(:external_id) { label 'External ID' }
    field :external_site, :enum do
      enum do
        {
          'MyAnimeList Anime' => 'myanimelist/anime',
          'MyAnimeList Manga' => 'myanimelist/manga',
          'MyAnimeList Characters' => 'myanimelist/character',
          'MyAnimeList People' => 'myanimelist/people',
          'MyAnimeList Producers' => 'myanimelist/producer',
          'AniList Anime' => 'anilist/anime',
          'AniList Manga' => 'anilist/manga',
          'TheTVDB' => 'thetvdb',
          'TheTVDB Series' => 'thetvdb/series',
          'TheTVDB Season' => 'thetvdb/season',
          'AniDB' => 'anidb',
          'AnimeNewsNetwork' => 'animenewsnetwork',
          'MangaUpdates' => 'mangaupdates',
          'Hulu' => 'hulu',
          'IMDB Episodes' => 'imdb/episodes',
          'Aozora' => 'aozora',
          'Trakt' => 'trakt',
          'MyDramaList' => 'mydramalist'
        }
      end
    end
    include_all_fields
  end

  config.model 'Episode' do
    navigation_label 'Media'
    parent Anime
    fields :id, :media
    field :titles, :localized_string
    field :canonical_title
    field :description, :localized_text
    fields :number, :relative_number, :season_number, :airdate, :thumbnail
    field :length, :duration
    include_all_fields
  end

  config.model 'Streamer' do
    navigation_label 'Media'
    fields :id, :site_name
    include_all_fields
    exclude_fields :videos
  end

  config.model 'Video' do
    navigation_label 'Media'
    parent Episode
    fields :id, :url
    field :regions, :string_list
    field(:embed_data, :serialized) { html_attributes rows: '6', cols: '70' }
    fields :episode, :streamer
    field :subs, :string_list
    field :dubs, :string_list
    include_all_fields
  end

  config.model 'Character' do
    navigation_label 'Media'
    list do
      search_by :rails_admin_search
    end
    field :id
    field :names, :localized_string
    field :canonical_name
    field :other_names, :string_list
    field :description, :localized_text
    field :primary_media
    field :media_characters
    fields :image, :slug
    include_all_fields
    exclude_fields :mal_id
  end

  config.model 'Genre' do
    navigation_label 'Media'
  end

  config.model 'Category' do
    navigation_label 'Media'
    list do
      fields :id, :slug, :title, :nsfw, :parent, :children
    end
    fields :id, :slug, :title, :description, :nsfw, :parent, :children
  end

  config.model 'MediaStaff' do
    visible false
    field :person
    field :role
  end

  config.model 'MediaCharacter' do
    visible false
    field :character
    field :media
    field :voices
    field :role, :enum
  end

  config.model 'MediaProduction' do
    visible false
    field :company
    field :role, :enum
  end

  config.model 'MediaRelationship' do
    visible false
    field :source
    field :destination
    field :role, :enum
  end
end
