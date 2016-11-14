class CharacterResource < BaseResource
  attributes :slug, :name, :image, :mal_id, :description

  has_one :primary_media, polymorphic: true
  has_many :castings

  filter :slug

  index CharactersIndex::Character
  query :name,
    mode: :query,
    apply: -> (values, _ctx) {
      {
        multi_match: {
          fields: %w[name people media],
          query: values.join(' '),
          fuzziness: 2,
          max_expansions: 15,
          prefix_length: 2
        }
      }
    }
end
