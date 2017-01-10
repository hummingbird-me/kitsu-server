class ProfileLinkResource < BaseResource
  attribute :url

  has_one :user
  has_one :profile_link_site
end
