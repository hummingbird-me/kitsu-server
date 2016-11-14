class CharactersIndex < Chewy::Index
  define_type Character.includes(castings: %i[media person]) do
    field :name
    field :people, value: -> (ch) {
      ch.castings&.map { |ca| ca&.person&.name }
    }
    field :media, value: -> (ch) {
      ch.castings&.flat_map { |ca| ca&.media&.titles }
    }
  end
end
