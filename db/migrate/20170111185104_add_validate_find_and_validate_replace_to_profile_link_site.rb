class AddValidateFindAndValidateReplaceToProfileLinkSite < ActiveRecord::Migration
  def change
    add_column :profile_link_sites, :validate_find, :string, null: false
    add_column :profile_link_sites, :validate_replace, :string, null: false
  end
end
