# frozen_string_literal: true

module TypesenseMediaIndex
  extend ActiveSupport::Concern

  included do
    schema do
      token_separators(*%w[/ - ( ) + ; : & , .])

      # Poster
      field 'poster_image', type: 'object', optional: true, facet: false, index: false

      # Titles
      field 'canonical_title', type: 'string'
      field 'romanized_title', type: 'string', optional: true
      field 'original_title', type: 'string', optional: true
      field 'translated_title', type: 'string', optional: true
      field 'alternative_titles', type: 'string[]'
      field 'titles', type: 'object'
      field 'titles\..*', type: 'string'

      # Start and end dates
      field 'start_date', type: 'object', optional: true
      field 'start_date.year', type: 'int32', facet: true, optional: true
      field 'start_date.month', type: 'int32', facet: true, optional: true
      field 'start_date.day', type: 'int32', facet: true, optional: true
      field 'start_date.timestamp', type: 'int64', optional: true
      field 'end_date', type: 'object', optional: true
      field 'end_date.year', type: 'int32', facet: true, optional: true
      field 'end_date.month', type: 'int32', facet: true, optional: true
      field 'end_date.day', type: 'int32', facet: true, optional: true
      field 'end_date.timestamp', type: 'int64', optional: true

      field 'age_rating', type: 'string', facet: true, optional: true
      field 'subtype', type: 'string', facet: true
      field 'user_count', type: 'int32', facet: true
      field 'favorites_count', type: 'int32', facet: true
      field 'average_rating', type: 'float', facet: true, optional: true

      field 'categories', type: 'int32[]', facet: true
      field 'genres', type: 'int32[]', facet: true
    end
  end
end
