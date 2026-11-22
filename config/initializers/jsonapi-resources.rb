# frozen_string_literal: true

require Rails.root.join('vendor/resource_serializer')
require Rails.root.join('lib/instrumented_processor')

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

      current[:include_related][fragment] ||= { include: false, include_related: {},
                                                include_in_join: }
      current = current[:include_related][fragment]
    end
    current
  end
end
JSONAPI::IncludeDirectives.prepend(FixIncludeErrors)

# HACK: JSONAPI::Resources' route helpers (jsonapi_resources/jsonapi_resource) still pass their
# options to the router as a positional hash. Rails 8.1 deprecates that for resources/resource and
# no longer accepts it in Mapper::Resources::Resource.new, so convert it to keywords on the way in.
module PositionalRouteOptions
  module Mapper
    def resources(*args, **options, &)
      options = args.pop.merge(options) if args.last.is_a?(Hash)
      super
    end

    def resource(*args, **options, &)
      options = args.pop.merge(options) if args.last.is_a?(Hash)
      super
    end
  end

  module Resource
    def initialize(entities, api_only, shallow, positional = nil, **options)
      super(entities, api_only, shallow, **positional.to_h, **options)
    end
  end
end
ActionDispatch::Routing::Mapper.prepend(PositionalRouteOptions::Mapper)
ActionDispatch::Routing::Mapper::Resources::Resource.prepend(PositionalRouteOptions::Resource)
ActionDispatch::Routing::Mapper::Resources::SingletonResource
  .prepend(PositionalRouteOptions::Resource)

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
  config.resource_cache_usage_report_function = ->(resource, hits, misses) do
    JSONAPI_RESOURCES_CACHE_HITS_TOTAL.observe(hits, resource:)
    JSONAPI_RESOURCES_CACHE_MISSES_TOTAL.observe(misses, resource:)
  end
end
