class MediaCharacterResource < BaseResource
  immutable
  attribute :role

  has_one :media, polymorphic: true
  has_one :character
  has_many :voices

  filter :role, apply: ->(records, values, _opts) {
    values = values.map { |v| records.roles[v] || v }
    records.where(roles: values)
  }
end
