# frozen_string_literal: true

class KitsuSchema < GraphQL::Schema
  default_max_page_size 2000

  mutation Types::MutationType
  query Types::QueryType

  use GraphQL::Batch
  tracer SentryTracing

  query_analyzer Analysis::MaxNodeLimit
  query_analyzer Analysis::PrometheusMetrics

  def self.resolve_type(_type, object, _context)
    "Types::#{object.class.name}".safe_constantize
  end
end
