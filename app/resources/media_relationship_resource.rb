class MediaRelationshipResource < BaseResource
  attribute :role

  filter :role, apply: ->(records, values, _options) {
    roles = MediaRelationship.roles.values_at(*values).compact
    roles = values if roles.empty?
    records.where(role: roles)
  }

  has_one :source, polymorphic: true
  has_one :destination, polymorphic: true
end
