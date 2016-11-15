class MediaFollowResource < BaseResource
  has_one :user
  has_one :media, polymorphic: true
end
