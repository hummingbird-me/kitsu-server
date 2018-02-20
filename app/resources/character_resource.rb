class CharacterResource < BaseResource
  attributes :slug, :names, :canonical_name, :other_names, :name, :mal_id, :description
  attribute :image, format: :attachment

  has_one :primary_media, polymorphic: true
  has_many :castings

  filter :slug

  index CharactersIndex::Character
  query :name,
    mode: :query,
    apply: ->(values, _ctx) {
      CharactersIndex::Character.query_for(values.join(' '))
    }

  def name
    _model.canonical_name
  end

  def name=(value)
    _model.names['en'] = value
  end
end
