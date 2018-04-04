class ProfileLinkSiteResource < BaseResource
  immutable
  paginator :unlimited
  attribute :name
end
