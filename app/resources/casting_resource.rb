class CastingResource < BaseResource
  attributes :role, :voice_actor, :featured, :language
  key_type :string
  model_hint model: MediaCasting, resource: :casting
  exclude_links :default

  has_one :media, polymorphic: true, exclude_links: :default
  has_one :character, exclude_links: :default
  has_one :person, exclude_links: :default

  filters :media_id, :media_type, :language, :featured
  filter :is_character, apply: ->(records, _v, _o) {
    records.where.not(character_id: nil)
  }

  # HACK: Arel is getting confused and returning a string for an integer column
  def self.pluck_arel_attributes(relation, *attrs)
    super.map do |row|
      [row[0], row[1].to_i]
    end
  end

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
