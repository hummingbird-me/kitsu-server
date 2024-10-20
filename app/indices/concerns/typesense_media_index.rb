# frozen_string_literal: true

module TypesenseMediaIndex
  extend ActiveSupport::Concern

  included do
    schema do
      token_separators(*%w[/ - ( ) + ; : & , .])

      # Locale-specific strings
      # Pulled from https://typesense.org/docs/0.24.0/api/collections.html#schema-parameters
      field '.*\.ja-.*', type: 'string*', locale: 'ja'
      field '.*\.zh-.*', type: 'string*', locale: 'zh'
      field '.*\.ko-.*', type: 'string*', locale: 'ko'
      field '.*\.th-.*', type: 'string*', locale: 'th'
      field '.*\.el-.*', type: 'string*', locale: 'el'
      field '.*\.ru-.*', type: 'string*', locale: 'ru'
      field '.*\.sr-.*', type: 'string*', locale: 'sr'
      field '.*\.uk-.*', type: 'string*', locale: 'uk'
      field '.*\.be-.*', type: 'string*', locale: 'be'

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
      field 'start_date.is_null', type: 'bool', facet: true, optional: true
      field 'start_date.year', type: 'int32', facet: true, optional: true
      field 'start_date.month', type: 'int32', facet: true, optional: true
      field 'start_date.day', type: 'int32', facet: true, optional: true
      field 'start_date.timestamp', type: 'int64', optional: true
      field 'end_date', type: 'object', optional: true
      field 'end_date.is_null', type: 'bool', facet: true, optional: true
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
