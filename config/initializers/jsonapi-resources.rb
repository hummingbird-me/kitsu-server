# frozen_string_literal: true

require Rails.root.join('lib/instrumented_processor')
require Rails.root.join('lib/resource_serializer_compat')

JSONAPI_RESOURCES_CACHE_HITS_TOTAL = $prometheus.register(
  :counter,
  'jsonapi_resources_cache_hits_total',
  'Number of cache hits for JSONAPI::Resources'
)

JSONAPI_RESOURCES_CACHE_MISSES_TOTAL = $prometheus.register(
  :counter,
  'jsonapi_resources_cache_misses_total',
  'Number of cache misses for JSONAPI::Resources'
)

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

  # Instrumentation
  config.default_processor_klass_name = 'InstrumentedProcessor'
  config.resource_cache_usage_report_function = ->(resource, hits, misses) do
    JSONAPI_RESOURCES_CACHE_HITS_TOTAL.observe(hits, resource:)
    JSONAPI_RESOURCES_CACHE_MISSES_TOTAL.observe(misses, resource:)
  end
end
