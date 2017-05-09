class SiteAnnouncementResource < BaseResource
  caching

  attributes :title, :description, :image_url, :link

  has_one :user
end
