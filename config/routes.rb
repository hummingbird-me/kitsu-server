# rubocop:disable Metrics/BlockLength
require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
  scope '/api' do
    scope '/edge' do
      ### Users
      jsonapi_resources :users
      post '/users/_recover', to: 'users#recover'
      get '/users/:id/_strength', to: 'users#profile_strength'
      # Profile data
      jsonapi_resources :profile_links
      jsonapi_resources :profile_link_sites
      # Follows/Blocks/Memberships
      jsonapi_resources :follows do
        post :import_from_facebook, on: :collection
        post :import_from_twitter, on: :collection
      end
      jsonapi_resources :media_follows
      jsonapi_resources :post_follows
      jsonapi_resources :blocks
      # Imports & Linked Accounts
      jsonapi_resources :linked_accounts
      jsonapi_resources :list_imports
      jsonapi_resources :library_entry_logs
      # Permissions
      jsonapi_resources :user_roles
      jsonapi_resources :roles

      ### Library
      delete '/library-entries/_bulk', to: 'library_entries#bulk_delete'
      patch '/library-entries/_bulk', to: 'library_entries#bulk_update'
      put '/library-entries/_bulk', to: 'library_entries#bulk_update'
      jsonapi_resources :library_entries

      jsonapi_resources :favorites

      ### Categories
      jsonapi_resources :category_favorites
      jsonapi_resources :categories

      ### Media
      jsonapi_resources :anime
      jsonapi_resources :manga
      jsonapi_resources :drama
      # Cast Info
      jsonapi_resources :anime_characters
      jsonapi_resources :anime_castings
      jsonapi_resources :anime_staff
      jsonapi_resources :drama_characters
      jsonapi_resources :drama_castings
      jsonapi_resources :drama_staff
      jsonapi_resources :manga_characters
      jsonapi_resources :manga_staff
      # Other Info
      jsonapi_resources :mappings
      jsonapi_resources :genres
      jsonapi_resources :streaming_links
      jsonapi_resources :streamers
      jsonapi_resources :media_relationships
      jsonapi_resources :anime_productions
      jsonapi_resources :episodes
      jsonapi_resources :stats
      # DEPRECATED: Legacy systems
      jsonapi_resources :castings
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
      get '/recommendations/:namespace', to: 'recommendations#index'

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
      resources :activities, only: %i[destroy]
      get '/feeds/:group/:id', to: 'feeds#show'
      post '/feeds/:group/:id/_read', to: 'feeds#mark_read'
      post '/feeds/:group/:id/_seen', to: 'feeds#mark_seen'
      delete '/feeds/:group/:id/activities/:uuid', to: 'feeds#destroy_activity'

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
      # Integrations
      get '/sso/canny', to: 'sso#canny'
    end

    ### Admin Panel
    constraints(AdminConstraint) do
      mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
      mount Sidekiq::Web => '/sidekiq'
      mount PgHero::Engine => '/pghero'
    end
    get '/admin', to: 'sessions#redirect'
    get '/sidekiq', to: 'sessions#redirect'
    get '/pghero', to: 'sessions#redirect'
    resources :sessions, only: %i[new create]

    ### WebHooks
    get '/hooks/youtube', to: 'webhooks#youtube_verify'
    post '/hooks/youtube', to: 'webhooks#youtube_notify'

    ### Staging Sync
    post '/user/_prodsync', to: 'users#prod_sync'

    ### Authentication
    use_doorkeeper

    root to: 'home#index'
  end
end