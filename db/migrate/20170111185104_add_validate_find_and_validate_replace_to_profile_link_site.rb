class AddValidateFindAndValidateReplaceToProfileLinkSite < ActiveRecord::Migration[4.2]
  def change
    add_column :profile_link_sites, :validate_find, :string
    add_column :profile_link_sites, :validate_replace, :string
  end
end
