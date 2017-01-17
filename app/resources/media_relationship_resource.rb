class MediaRelationshipResource < BaseResource
  attribute :role

  has_one :source, polymorphic: true
  has_one :destination, polymorphic: true
end
