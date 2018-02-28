class CullForeignKeyConstraints < ActiveRecord::Migration
  def change
    # Foreign keys to User model
    remove_foreign_key :ama_subscribers, :users
    remove_foreign_key :amas, column: 'author_id'
    remove_foreign_key :blocks, :users
    remove_foreign_key :comment_likes, :users
    remove_foreign_key :community_recommendation_follows, :users
    remove_foreign_key :community_recommendation_requests, :users
    remove_foreign_key :group_bans, :users
    remove_foreign_key :group_invites, :users
    remove_foreign_key :group_member_notes, :users
    remove_foreign_key :group_reports, :users
    remove_foreign_key :group_tickets, :users
    remove_foreign_key :leader_chat_messages, :users
    remove_foreign_key :library_events, :users
    remove_foreign_key :linked_accounts, :users
    remove_foreign_key :media_attribute_votes, :users
    remove_foreign_key :media_ignores, :users
    remove_foreign_key :media_reaction_votes, :users
    remove_foreign_key :media_reactions, :users
    remove_foreign_key :notification_settings, :users
    remove_foreign_key :one_signal_players, :users
    remove_foreign_key :post_follows, :users
    remove_foreign_key :posts, :users
    remove_foreign_key :profile_links, :users
    remove_foreign_key :reports, :users
    remove_foreign_key :review_likes, :users
    remove_foreign_key :stats, :users
    remove_foreign_key :uploads, :users
    remove_foreign_key :user_ip_addresses, :users

    # Foreign keys to LibraryEntry model
    remove_foreign_key :reviews, :library_entries
    remove_foreign_key :media_reactions, :library_entries
    remove_foreign_key :library_events, :library_entries

    # Foreign keys to Media models
    remove_foreign_key :anime_characters, :anime
    remove_foreign_key :anime_media_attributes, :anime
    remove_foreign_key :anime_staff, :anime
    remove_foreign_key :community_recommendations, :anime
    remove_foreign_key :community_recommendations, :dramas
    remove_foreign_key :community_recommendations, :manga
    remove_foreign_key :drama_characters, :dramas
    remove_foreign_key :drama_staff, :dramas
    remove_foreign_key :manga_characters, :manga
    remove_foreign_key :manga_media_attributes, :manga
    remove_foreign_key :manga_staff, :manga
    remove_foreign_key :media_reactions, :anime
    remove_foreign_key :media_reactions, :manga
    remove_foreign_key :media_reactions, :dramas
  end
end
