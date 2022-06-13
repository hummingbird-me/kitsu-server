class CastingResource < BaseResource
  attributes :role, :voice_actor, :featured, :language
  model_hint model: MediaCasting, resource: :casting

  has_one :media, polymorphic: true
  has_one :character
  has_one :person

  filters :media_id, :media_type, :language, :featured
  filter :is_character, apply: ->(records, _v, _o) {
    records.where.not(character_id: nil)
  }

  def self._model_name
    if Flipper[:media_castings].enabled?(User.current)
      'MediaCasting'
    else super
    end
  end

  def self._model_class
    if Flipper[:media_castings].enabled?(User.current)
      MediaCasting
    else super
    end
  end
end
