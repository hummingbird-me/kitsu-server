class MediaStaffResource < BaseResource
  attribute :role

  has_one :media, polymorphic: true
  has_one :person
end
