class MediaIgnoreResource < BaseResource
  has_one :user
  has_one :media, polymorphic: true

  filters :user_id, :media_id, :media_type
end
