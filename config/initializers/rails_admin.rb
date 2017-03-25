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
      only ['Anime', 'Manga', 'Groups', 'User']
    end
  end

  # Display canonical_title for label on media
  config.label_methods += %i[canonical_title site_name]

  # Omitted for security reasons (and Franchise/Casting/Installment deprecated)
  config.excluded_models += %w[
    LeaderChatMessage LinkedAccount GroupTicketMessage PostLike ProfileLink
    ReviewLike UserRole Role GroupTicket Franchise Casting Report CommentLike
    Installment LinkedAccount::MyAnimeList
  ]

  # Anime
  config.model 'Anime' do
    field(:titles, :serialized) { html_attributes rows: '6', cols: '70' }
    field :abbreviated_titles, :serialized do
      html_attributes rows: '6', cols: '70'
    end
    fields :canonical_title, :synopsis, :slug, :subtype, :poster_image,
      :cover_image, :age_rating, :age_rating_guide, :episode_count
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
    field(:titles, :serialized) { html_attributes rows: '6', cols: '70' }
    field :abbreviated_titles, :serialized do
      html_attributes rows: '6', cols: '70'
    end
    fields :canonical_title, :synopsis, :slug, :subtype, :poster_image,
      :cover_image, :age_rating, :age_rating_guide, :chapter_count,
      :volume_count
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
    field :manga_id
    field(:titles, :serialized) { html_attributes rows: '6', cols: '70' }
    fields :canonical_title, :number, :synopsis, :published, :volume, :length
    include_all_fields
    navigation_label 'Chapters'
  end
  # Drama
  config.model 'Drama' do
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
    fields :name, :email, :about, :avatar, :cover_image
    include_all_fields
    exclude_fields :password_digest, :remember_created_at, :current_sign_in_at,
      :last_sign_in_at, :recommendations_up_to_date, :facebook_id, :twitter_id,
      :mal_username, :life_spent_on_anime, :bio, :ninja_banned, :to_follow,
      :dropbox_token, :dropbox_secret, :last_backup, :stripe_token,
      :stripe_customer_id, :import_status, :import_from, :import_error,
      :profile_completed, :feed_completed, :followers, :following, :comments,
      :posts, :media_follows, :blocks, :last_recommendations_update, :title,
      :library_entries
    navigation_label 'Users'
    weight(-10)
  end
  config.model('ListImport') { parent User }
  config.model('Favorite') { parent User }
  config.model('Marathon') { parent User }
  config.model('MarathonEvent') { parent User }
  config.model('Block') { parent User }
  config.model('Follow') { parent User }
  config.model('MediaFollow') { parent User }
  config.model('LibraryEntry') { parent User }

  config.model('MediaRelationship') { visible false }
  config.model('LibraryEntryLog') { visible false }

  # Feed
  config.model('Comment') { parent Post }

  config.model 'Mapping' do
    field(:external_id) { label 'External ID' }
    field :external_site, :enum do
      enum do
        {
          'MyAnimeList Anime' => 'myanimelist/anime',
          'MyAnimeList Manga' => 'myanimelist/manga'
        }
        # %w[myanimelist/anime myanimelist/manga animenewsnetwork anidb
        #    thetvdb/series thetvdb/season mydramalist ]
      end
    end
  end
end
