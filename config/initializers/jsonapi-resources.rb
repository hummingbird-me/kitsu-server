require Rails.root.join('vendor/resource_serializer')
require Rails.root.join('lib/instrumented_processor')
require_relative 'prometheus_exporter'

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

module FixIncludeErrors
  def get_related(current_path)
    current = @include_directives_hash
    current_resource_klass = @resource_klass
    current_path.split('.').each do |fragment|
      fragment = fragment.to_sym

      if current_resource_klass
        current_relationship = current_resource_klass._relationships[fragment]
        current_resource_klass = current_relationship.try(:resource_klass)
      end

      include_in_join = @force_eager_load || !current_relationship || current_relationship.eager_load_on_include

      current[:include_related][fragment] ||= { include: false, include_related: {}, include_in_join: include_in_join }
      current = current[:include_related][fragment]
    end
    current
  end
end
JSONAPI::IncludeDirectives.prepend(FixIncludeErrors)

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
  config.default_processor_klass = InstrumentedProcessor
  config.resource_cache_usage_report_function = lambda do |resource, hits, misses|
    JSONAPI_RESOURCES_CACHE_HITS_TOTAL.observe(hits, resource: resource)
    JSONAPI_RESOURCES_CACHE_MISSES_TOTAL.observe(misses, resource: resource)
  end
end
