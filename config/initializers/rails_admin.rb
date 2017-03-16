RailsAdmin.config do |config|
  config.parent_controller = '::AdminController'
  config.current_user_method(&:current_user)

  config.authorize_with do
    redirect_to main_app.root_path unless current_user.admin?
  end

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
    delete do
      controller do
        proc do
          if request.get? # DELETE

            respond_to do |format|
              format.html { render @action.template_name }
              format.js   { render @action.template_name, layout: false }
            end

          elsif request.delete? # DESTROY

            redirect_path = nil
            @auditing_adapter&.delete_object(@object, @abstract_model,
                                             _current_user)
            if @object.destroy
              flash[:success] = t('admin.flash.successful',
                name: @model_config.label,
                action: t('admin.actions.delete.done'))
              redirect_path = '/api' + index_path
            else
              flash[:error] = t('admin.flash.error',
                name: @model_config.label,
                action: t('admin.actions.delete.done'))
              redirect_path = '/api' + back_or_index
            end

            redirect_to redirect_path

          end
        end
      end
    end
    history_show
  end

  # Display canonical_title for label on media
  config.label_methods << :canonical_title

  # Omitted for security reasons (and Franchise/Casting/Installment deprecated)
  config.excluded_models += %w[
    LeaderChatMessage LinkedAccount GroupTicketMessage PostLike ProfileLink
    ReviewLike UserRole Role GroupTicket Franchise Casting Report CommentLike
    Installment LinkedAccount::MyAnimeList
  ]

  # Anime
  config.model 'Anime' do
    exclude_fields :library_entries, :inverse_media_relationships, :favorites,
      :producers, :average_rating, :cover_image_top_offset
    navigation_label 'Anime'
  end
  config.model('AnimeCasting') { parent Anime }
  config.model('AnimeCharacter') { parent Anime }
  config.model('AnimeProduction') { parent Anime }
  config.model('AnimeStaff') { parent Anime }
  # Manga
  config.model 'Manga' do
    navigation_label 'Manga'
  end
  config.model('MangaCharacter') { parent Manga }
  config.model('MangaStaff') { parent Manga }
  config.model('Chapter') { parent Manga }
  # Drama
  config.model 'Drama' do
    navigation_label 'Drama'
  end
  config.model('DramaCasting') { parent Drama }
  config.model('DramaCharacter') { parent Drama }
  config.model('DramaStaff') { parent Drama }

  # Groups
  config.model 'Groups' do
    navigation_label 'Groups'
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
      :posts, :media_follows, :blocks, :last_recommendations_update, :title
    navigation_label 'Users'
  end
  config.model('ListImport') { parent User }
  config.model('Favorite') { parent User }
  config.model('Marathon') { parent User }
  config.model('MarathonEvent') { parent User }

  # Feed
  config.model('Comment') { parent Post }
end
