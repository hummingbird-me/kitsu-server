class CharacterVoicesResource < BaseResource
  immutable
  attribute :locale

  has_one :media, polymorphic: true
  has_one :person
  has_one :licensor
end
