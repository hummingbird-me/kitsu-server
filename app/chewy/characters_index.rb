class CharactersIndex < Chewy::Index
  define_type Character.includes(castings: %i[media person]) do
    def self.query_for(query)
      fields = %w[name^2 people media]
      {
        bool: {
          must: {
            multi_match: {
              query: query,
              fields: fields,
              fuzziness: 2,
              max_expansions: 15,
              prefix_length: 2
            }
          },
          should: [
            {
              multi_match: {
                type: 'phrase',
                slop: 50,
                query: query,
                fields: fields,
                fuzziness: 2,
                max_expansions: 15,
                prefix_length: 2,
                boost: 2
              }
            },
            {
              multi_match: {
                type: 'most_fields',
                query: query,
                fields: fields,
                boost: 3
              }
            }
          ]
        }
      }
    end

    field :updated_at
    field :name
    field :people, value: -> (ch) {
      ch.castings.map { |ca| ca.person&.name }.uniq.reject(&:blank?)
    }
    field :media, value: -> (ch) {
      ch.castings.flat_map { |ca|
        ca.media&.titles&.values
      }.uniq.reject(&:blank?)
    }
  end
end
