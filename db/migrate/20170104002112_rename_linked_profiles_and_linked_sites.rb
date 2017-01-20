class RenameLinkedProfilesAndLinkedSites < ActiveRecord::Migration
  def change
    # rename LinkedProfile -> LinkedAccount
    rename_table :linked_profiles, :linked_accounts
    # remove LinkedSite association + will remove index
    remove_column :linked_accounts, :linked_site_id, :integer
    # remove url
    remove_column :linked_accounts, :url, :string
    # remove private (was used with url)
    remove_column :linked_accounts, :private, :boolean
    # add type for STI
    add_column :linked_accounts, :type, :string, null: false
    # add sync_to (for any external services like mal)
    add_column :linked_accounts, :sync_to, :boolean, default: false, null: false

    # Rename LinkedSite -> ProfileLinkedSite
    rename_table :linked_sites, :profile_link_sites
    # remove share_to, share_from, link_type
    remove_column :profile_link_sites, :share_to, :boolean
    remove_column :profile_link_sites, :share_from, :boolean
    remove_column :profile_link_sites, :link_type, :string

    # Create ProfileLink Table
    create_table(:profile_links) do |t|
      t.references :user, null: false, index: true
      t.references :profile_link_site, null: false, index: true
      t.string :url, null: false

      t.index [:user_id, :profile_link_site_id], unique: true
    end
    add_foreign_key :profile_links, :users
    add_foreign_key :profile_links, :profile_link_sites
  end
end
