class MediaResource < BaseResource
  include SluggableResource

  abstract

  # This regex accepts a numerical range or single number
  # $1 = start, $2 = dot representing closed/open, $3 = end
  NUMBER = /(\d+(?:\.\d+)?)/
  NUMERIC_RANGE = /\A#{NUMBER}?(\.{2,3})?#{NUMBER}?\z/
  NUMERIC_QUERY = {
    valid: ->(value, _ctx) do
      matches = NUMERIC_RANGE.match(value)
      # You gotta provide at least *one* number
      matches && (matches[1].present? || matches[3].present?)
    end,
    apply: ->(values, _ctx) do
      # We only accept the first value
      values.map do |value|
        matches = NUMERIC_RANGE.match(value)
        inclusive = matches[2] == '..'

        if matches[2] # Range
          if matches[1] && matches[3] # Double-ended
            Range.new(matches[1].to_f, matches[3].to_f, !inclusive)
          elsif matches[1] # start...
            key = inclusive ? 'gte' : 'gt'
            { range: { '$field' => { key => matches[1] } } }
          else # ...end
            key = inclusive ? 'lte' : 'lt'
            { range: { '$field' => { key => matches[3] } } }
          end
        else # Scalar
          matches[1]
        end
      end
    end
  }.freeze

  caching

  attributes :synopsis,
    # Cover image location
    :cover_image_top_offset,
    # Titles
    :titles, :canonical_title, :abbreviated_titles,
    # Ratings
    :average_rating, :rating_frequencies, :user_count, :favorites_count,
    # Dates
    :start_date, :end_date,
    # Rankings
    :popularity_rank, :rating_rank,
    # Age Ratings
    :age_rating, :age_rating_guide,
    # Subtype
    :subtype,
    # Airing/Publishing Status
    :status, :tba
  # Images
  attributes :poster_image, :cover_image, format: :attachment

  has_many :genres
  has_many :categories
  has_many :castings
  has_many :installments
  has_many :mappings
  has_many :reviews
  has_many :media_relationships

  filter :subtype, apply: ->(records, values, _opts) {
    values = values.map { |v| records.subtypes[v] || v }
    records.where(subtype: values)
  }
  filter :status, apply: ->(records, values, _opts) {
    values.inject(records.none) do |query, value|
      if %w[tba unreleased upcoming current finished].include? value
        query.or(records.send(value))
      else
        query
      end
    end
  }
  filter :since, apply: ->(records, values, _options) {
    time = values.join.to_time
    records.where('updated_at >= ?', time)
  }

  # Common ElasticSearch stuff
  query :year, NUMERIC_QUERY
  query :average_rating, NUMERIC_QUERY
  query :user_count, NUMERIC_QUERY
  query :subtype
  query :status
  query :genres,
    apply: ->(values, _ctx) {
      { match: { genres: { query: values.join(' '), operator: 'and' } } }
    }
  query :categories,
    apply: ->(values, _ctx) {
      { match: { categories: { query: values.join(' '), operator: 'and' } } }
    }
  query :text,
    mode: :query,
    apply: ->(values, _ctx) {
      {
        function_score: {
          script_score: {
            lang: 'expression',
            script: "max(log10(doc['user_count'].value), 1) * _score"
          },
          query: {
            bool: {
              should: [
                { multi_match: {
                  fields: %w[
                    titles.* abbreviated_titles synopsis people characters
                  ],
                  query: values.join(' '),
                  fuzziness: 2,
                  max_expansions: 15,
                  prefix_length: 2
                } },
                { multi_match: {
                  fields: %w[titles.* abbreviated_titles],
                  query: values.join(' '),
                  boost: 1.2
                } }
              ]
            }
          }
        }
      }
    }

  def self.updatable_fields(context)
    super - [:status]
  end

  def self.creatable_fields(context)
    super - [:status]
  end
end
