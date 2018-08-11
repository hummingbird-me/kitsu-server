class MediaProductionResource < BaseResource
  immutable
  attribute :role

  has_one :media, polymorphic: true
  has_one :company

  filter :role, apply: ->(records, values, _opts) {
    values = values.map { |v| records.roles[v] || v }
    records.where(roles: values)
  }
end
