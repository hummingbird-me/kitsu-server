require Rails.root.join('lib/rails_admin/config/fields/types/citext')

RailsAdmin::ApplicationHelper.module_exec do
  def edit_user_link
    link_to "/users/#{_current_user.name}" do
      html = []
      html << image_tag(_current_user.avatar.to_s(:small), height: 30, width: 30)
      html << content_tag(:span, _current_user.name)
      html.join.html_safe
    end
  end
end

RailsAdmin.config do |config| # rubocop:disable Metrics/BlockLength
  config.parent_controller = '::AdminController'
  config.current_user_method(&:current_user)

  config.authorize_with :pundit

  ## == PaperTrail ==
  config.audit_with :history

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
          redirect_to "https://kitsu.io/#{namespace}/#{slug}"
        end
      end
    end
  end

  # Display as scrollable list
  config.total_columns_width = 9_999_999

  # Display canonical_title for label on media
  config.label_methods += %i[canonical_title site_name]

  # Omitted for security reasons (and Casting is deprecated)
  config.excluded_models += %w[
    LeaderChatMessage LinkedAccount GroupTicketMessage PostLike ProfileLink ReviewLike UserRole Role
    GroupTicket Casting Report CommentLike LinkedAccount::MyAnimeList MediaAttributeVote
    LinkedAccount::YoutubeChannel UserIpAddress
  ]

  # Franchise
  config.model 'Franchise'
  config.model('Installment') { parent Franchise }
  # Anime
  config.model 'Anime' do
    field :id
    field(:titles, :serialized) { html_attributes rows: '6', cols: '70' }
    field :abbreviated_titles, :serialized do
      html_attributes rows: '6', cols: '70'
    end
    fields :canonical_title, :synopsis, :slug, :subtype, :poster_image, :cover_image,
      :age_rating, :age_rating_guide, :episode_count, :episode_count_guess
    include_all_fields
    exclude_fields :library_entries, :inverse_media_relationships, :favorites,
      :producers, :average_rating, :cover_image_top_offset
    navigation_label 'Anime'
    weight(-20)
  end
  config.model('AnimeCasting') { parent Anime }
  config.model('AnimeCharacter') { parent Anime }
  config.model('AnimeProduction') { parent Anime }
  config.model('AnimeStaff') { parent Anime }
  # Manga
  config.model 'Manga' do
    field :id
    field(:titles, :serialized) { html_attributes rows: '6', cols: '70' }
    field :abbreviated_titles, :serialized do
      html_attributes rows: '6', cols: '70'
    end
    fields :canonical_title, :synopsis, :slug, :subtype, :poster_image, :cover_image,
      :age_rating, :age_rating_guide, :chapter_count, :chapter_count_guess, :volume_count
    include_all_fields
    exclude_fields :library_entries, :inverse_media_relationships, :favorites,
      :average_rating, :cover_image_top_offset
    navigation_label 'Manga'
    weight(-15)
  end
  config.model('MangaCharacter') { parent Manga }
  config.model('MangaStaff') { parent Manga }
  config.model 'Chapter' do
    parent Manga
    fields :id, :manga
    field(:titles, :serialized) { html_attributes rows: '6', cols: '70' }
    fields :canonical_title, :number, :synopsis, :published, :volume_number,
      :length, :thumbnail
    include_all_fields
    navigation_label 'Chapters'
  end
  # Drama
  config.model 'Drama' do
    field :id
    field(:titles, :serialized) { html_attributes rows: '6', cols: '70' }
    field :abbreviated_titles, :serialized do
      html_attributes rows: '6', cols: '70'
    end
    fields :canonical_title, :synopsis, :slug, :subtype, :poster_image,
      :cover_image, :age_rating, :age_rating_guide
    include_all_fields
    navigation_label 'Drama'
    weight(0)
  end
  config.model('DramaCasting') { parent Drama }
  config.model('DramaCharacter') { parent Drama }
  config.model('DramaStaff') { parent Drama }

  # Groups
  config.model 'Groups' do
    navigation_label 'Groups'
    weight(-5)
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
      :library_entries, :slug
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
  config.model('Comment') { parent Post }
  config.model('Repost') { parent Post }
  config.model('Upload') { parent Post }

  config.model('MediaReactionVote') { parent MediaReaction }

  config.model('StreamingLink') { parent Streamer }

  config.model('Video') { parent Episode }

  config.model('AnimeMediaAttribute') { parent MediaAttribute }
  config.model('MangaMediaAttribute') { parent MediaAttribute }
  config.model('DramaMediaAttribute') { parent MediaAttribute }

  config.model('CommunityRecommendationFollow') { parent CommunityRecommendation }
  config.model('CommunityRecommendationRequest') { parent CommunityRecommendation }

  config.model('AMASubscriber') { parent AMA }

  config.model 'Mapping' do
    fields :id, :item
    field(:external_id) { label 'External ID' }
    field :external_site, :enum do
      enum do
        {
          'MyAnimeList Anime' => 'myanimelist/anime',
          'MyAnimeList Manga' => 'myanimelist/manga',
          'AniDB' => 'anidb',
          'AnimeNewsNetwork' => 'animenewsnetwork',
          'MangaUpdates' => 'mangaupdates',
          'Hulu' => 'hulu',
          'IMDB Episodes' => 'imdb/episodes',
          'TheTVDB Series' => 'thetvdb/series',
          'TheTVDB Season' => 'thetvdb/season',
          'MyDramaList' => 'mydramalist'
        }
      end
    end
    include_all_fields
  end

  config.model 'Episode' do
    fields :id, :media
    field(:titles, :serialized) { html_attributes rows: '6', cols: '70' }
    fields :canonical_title, :number, :relative_number, :season_number, :synopsis, :airdate,
      :length, :thumbnail
    include_all_fields
    field :media_id do
      filterable true
    end
    field :media_type do
      filterable true
    end
  end

  config.model 'Streamer' do
    fields :id, :site_name
    include_all_fields
    exclude_fields :videos
  end
end
