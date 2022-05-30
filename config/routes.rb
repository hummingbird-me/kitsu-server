require 'sidekiq/web'

Rails.application.routes.draw do
  scope '/api' do
    mount HealthBit.rack => '/_health'
    post '/graphql', to: 'graphql#execute'
    get '/playground', to: 'graphql_playground#show'
    get '/graphiql', to: redirect('/api/playground')
    scope '/edge' do
      ### Users
      # These have to be first since they have precedence
      get '/users/_conflicts', to: 'users#conflicts_index'
      post '/users/_conflicts', to: 'users#conflicts_update'
      post '/users/_unsubscribe', to: 'users#unsubscribe'
      jsonapi_resources :users
      post '/users/_recover', to: 'users#recover'
      post '/users/_confirm', to: 'users#confirm'
      get '/users/:id/_alts', to: 'users#alts'
      post '/users/:id/_ban', to: 'users#ban'
      delete '/users/:id/_ban', to: 'users#unban'
      post '/users/:id/_nuke', to: 'users#destroy_content'
      get '/_flags', to: 'users#flags'
      # Profile data
      jsonapi_resources :profile_links
      jsonapi_resources :profile_link_sites
      # Follows/Blocks/Memberships
      jsonapi_resources :follows do
        post :import_from_facebook, on: :collection
        post :import_from_twitter, on: :collection
      end
      jsonapi_resources :media_ignores
      jsonapi_resources :post_follows
      jsonapi_resources :blocks
      # Imports & Linked Accounts
      jsonapi_resources :linked_accounts
      jsonapi_resources :list_imports
      jsonapi_resources :library_entry_logs
      # Permissions
      jsonapi_resources :user_roles
      jsonapi_resources :roles
      jsonapi_resources :notification_settings
      # One Signal Players
      jsonapi_resources :one_signal_players
      # Pro Subscriptions
      post '/pro-subscription/ios', to: 'pro_subscription#ios'
      post '/pro-subscription/google-play', to: 'pro_subscription#google_play'
      delete '/pro-subscription', to: 'pro_subscription#destroy'
      get '/pro-subscription', to: 'pro_subscription#show'

      ### Library
      get '/library-entries/_xml', to: 'library_entries#download_xml'
      get '/library-entries/_issues', to: 'library_entries#issues'
      delete '/library-entries/_bulk', to: 'library_entries#bulk_delete'
      patch '/library-entries/_bulk', to: 'library_entries#bulk_update'
      put '/library-entries/_bulk', to: 'library_entries#bulk_update'
      jsonapi_resources :library_entries
      jsonapi_resources :library_events
      jsonapi_resources :favorites

      ### AMA
      jsonapi_resources :amas
      jsonapi_resources :ama_subscribers

      ### Categories
      jsonapi_resources :category_favorites
      jsonapi_resources :categories

      ### Media
      jsonapi_resources :anime
      jsonapi_resources :manga
      jsonapi_resources :drama
      # Cast Info
      jsonapi_resources :media_characters
      jsonapi_resources :media_productions
      jsonapi_resources :media_staff
      jsonapi_resources :character_voices
      # Other Info
      jsonapi_resources :mappings
      jsonapi_resources :genres
      jsonapi_resources :media_relationships
      jsonapi_resources :media_attributes
      jsonapi_resources :media_attribute_votes
      jsonapi_resources :anime_media_attributes
      jsonapi_resources :dramas_media_attributes
      jsonapi_resources :manga_media_attributes
      jsonapi_resources :episodes
      jsonapi_resources :chapters
      jsonapi_resources :stats
      # Streaming
      jsonapi_resources :streaming_links
      jsonapi_resources :streamers
      jsonapi_resources :videos
      # DEPRECATED: Legacy systems
      jsonapi_resources :castings
      jsonapi_resources :anime_characters
      jsonapi_resources :anime_castings
      jsonapi_resources :anime_staff
      jsonapi_resources :drama_characters
      jsonapi_resources :drama_castings
      jsonapi_resources :drama_staff
      jsonapi_resources :manga_characters
      jsonapi_resources :manga_staff
      jsonapi_resources :anime_productions
      get '/anime/:anime_id/_languages', to: 'anime#languages'
      jsonapi_resources :franchises
      jsonapi_resources :installments
      # Reviews
      jsonapi_resources :reviews
      jsonapi_resources :review_likes
      # Media Reactions
      jsonapi_resources :media_reaction_votes
      jsonapi_resources :media_reactions
      # Trending
      get '/trending/:namespace', to: 'trending#index'

      # Community recommendations
      jsonapi_resources :community_recommendation_follows
      jsonapi_resources :community_recommendations
      jsonapi_resources :community_recommendation_requests

      ### People/Characters/Companies
      jsonapi_resources :characters
      jsonapi_resources :people
      jsonapi_resources :producers

      ### Feeds
      jsonapi_resources :posts
      jsonapi_resources :post_likes
      jsonapi_resources :comments
      jsonapi_resources :comment_likes
      jsonapi_resources :reports
      jsonapi_resources :reposts
      resources :activities, only: %i[destroy]
      get '/feeds/:group/:id', to: 'feeds#show'
      post '/feeds/:group/:id/_read', to: 'feeds#mark_read'
      post '/feeds/:group/:id/_seen', to: 'feeds#mark_seen'
      delete '/feeds/:group/:id/activities/:uuid', to: 'feeds#destroy_activity'
      post '/embeds', to: 'embeds#create'

      ### Site Announcements
      jsonapi_resources :site_announcements

      ### Groups
      jsonapi_resources :groups
      jsonapi_resources :group_members
      jsonapi_resources :group_permissions
      jsonapi_resources :group_neighbors
      jsonapi_resources :group_categories
      # Tickets
      jsonapi_resources :group_tickets
      jsonapi_resources :group_ticket_messages
      # Moderation
      jsonapi_resources :group_reports
      jsonapi_resources :group_bans
      jsonapi_resources :group_member_notes
      # Leader Chat
      jsonapi_resources :leader_chat_messages
      # Action logs
      jsonapi_resources :group_action_logs
      # Invites
      jsonapi_resources :group_invites
      post '/group-invites/:id/_accept', to: 'group_invites#accept'
      post '/group-invites/:id/_decline', to: 'group_invites#decline'
      post '/group-invites/:id/_revoke', to: 'group_invites#revoke'
      get '/groups/:id/_stats', to: 'groups#stats'
      post '/groups/:id/_read', to: 'groups#read'

      get '/algolia-keys/user', to: 'algolia_keys#user'
      get '/algolia-keys/posts', to: 'algolia_keys#posts'
      get '/algolia-keys/media', to: 'algolia_keys#media'
      get '/algolia-keys/groups', to: 'algolia_keys#groups'
      get '/algolia-keys/character', to: 'algolia_keys#character'
      get '/algolia-keys', to: 'algolia_keys#all'

      # Integrations
      get '/sso/canny', to: 'sso#canny'
      # Uploads
      post '/uploads/_bulk', to: 'uploads#bulk_create'
      jsonapi_resources :uploads
    end

    ### Admin Panel
    constraints(AdminConstraint) do
      mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
      mount Sidekiq::Web => '/sidekiq'
      mount PgHero::Engine => '/pghero'
      mount Flipper::UI.app(Flipper) => '/flipper'
    end
    get '/admin', to: 'sessions#redirect'
    get '/sidekiq', to: 'sessions#redirect'
    get '/pghero', to: 'sessions#redirect'
    get '/flipper', to: 'sessions#redirect'
    resources :sessions, only: %i[new create]

    ### Webhooks
    namespace :hooks, module: 'webhooks' do
      get :youtube, to: 'youtube#verify'
      post :youtube, to: 'youtube#notify'
      get :getstream, to: 'getstream#verify'
      post :getstream, to: 'getstream#notify'
      post :stripe, to: 'stripe#notify'
      post '/google-play-billing', to: 'google_play_billing#notify'
      post '/apple-ios-billing', to: 'apple_ios_billing#notify'
    end

    ### Authentication
    use_doorkeeper

    root to: 'home#index'
  end
  match '*any', to: 'error#not_found', via: :all
end
