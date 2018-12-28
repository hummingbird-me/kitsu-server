class CleanUpUserModel < ActiveRecord::Migration
  def up
    change_table :users do |t|
      # Recommendations V2
      t.remove :recommendations_up_to_date
      t.remove :last_recommendations_update
      # Old Bans
      t.remove :ninja_banned
      # Old (Devise) Login System
      t.remove :remember_created_at
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      # Old Dropbox Sync
      t.remove :dropbox_token
      t.remove :dropbox_secret
      t.remove :last_backup
      # Old Stats
      t.remove :life_spent_on_anime
      # Old Wikis
      t.remove :approved_edit_count
      t.remove :rejected_edit_count
      # Old Imports
      t.remove :import_status
      t.remove :import_from
      t.remove :import_error
      # Old IP Addresses
      t.remove :ip_addresses
      # Old About Info
      t.remove :about_formatted
      t.remove :bio
    end
  end
end
