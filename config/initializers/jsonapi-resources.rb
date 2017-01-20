JSONAPI.configure do |config|
  # Keying
  config.json_key_format = :camelized_key

  # Pagination
  config.default_paginator = :offset
  config.default_page_size = 10
  config.maximum_page_size = 20

  # Caching
  config.resource_cache = Rails.cache

  # Metadata
  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :count
end
