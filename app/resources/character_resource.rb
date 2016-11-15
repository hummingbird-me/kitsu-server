class CharacterResource < BaseResource
  attributes :slug, :name, :image, :mal_id, :description

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
