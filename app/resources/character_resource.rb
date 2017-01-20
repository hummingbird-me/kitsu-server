class CharacterResource < BaseResource
  attributes :slug, :name, :mal_id, :description
  attribute :image, format: :attachment

  has_one :primary_media, polymorphic: true
  has_many :castings

  filter :slug

  index CharactersIndex::Character
  query :name,
    mode: :query,
    apply: -> (values, _ctx) {
      CharactersIndex::Character.query_for(values.join(' '))
    }
end
