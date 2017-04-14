class SiteAnnouncementResource < BaseResource
  attributes :text, :link

  has_one :user
end
