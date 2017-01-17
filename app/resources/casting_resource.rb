class CastingResource < BaseResource
  attributes :role, :voice_actor, :featured, :language

  has_one :media, polymorphic: true
  has_one :character
  has_one :person

  filters :media_id, :media_type, :language, :featured
  filter :is_character, apply: ->(records, _v, _o) {
    records.where.not(character_id: nil)
  }
end
