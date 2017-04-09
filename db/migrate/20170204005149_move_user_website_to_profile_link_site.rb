class MoveUserWebsiteToProfileLinkSite < ActiveRecord::Migration
  def change
    User.where.not(website: nil).find_each do |user|
      ProfileLink.create(
        url: user.website.split(' ').first,
        profile_link_site_id: 29,
        user_id: user.id
      )
    end

    remove_column :users, :website
  end
end
