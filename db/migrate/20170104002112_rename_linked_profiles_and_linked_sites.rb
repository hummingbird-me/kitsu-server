class RenameLinkedProfilesAndLinkedSites < ActiveRecord::Migration
  def change
    # rename LinkedProfile -> LinkedAccount
    rename_table :linked_profiles, :linked_accounts
    # remove LinkedSite association + will remove index
    remove_column :linked_accounts, :linked_site_id, :integer
    # remove url
    remove_column :linked_accounts, :url, :string
    # add type for STI
    add_column :linked_accounts, :type, :string, null: false
    # add sync_to (for any external services like mal)
    add_column :linked_accounts, :sync_to, :boolean, default: false, null: false

    # Rename LinkedSite -> ProfileLinkedSite
    rename_table :linked_sites, :profile_linked_sites
    # Create ProfileLink Table
    create_table(:profile_links) do |t|
      t.references :user, index: true
      t.references :profile_linked_site, index: true
      t.string :url, null: false
      t.index [:user_id, :profile_link_site_id], unique: true
    end
  end
end
