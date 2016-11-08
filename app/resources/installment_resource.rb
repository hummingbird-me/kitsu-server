class InstallmentResource < BaseResource
  attributes :tag, :position

  has_one :franchise
  has_one :media, polymorphic: true

  filter :media_type
  filter :media_id
end
