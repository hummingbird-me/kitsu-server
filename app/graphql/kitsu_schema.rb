# frozen_string_literal: true

class KitsuSchema < GraphQL::Schema
  include ApolloFederation::Schema
  federation version: '2.0'

  default_max_page_size 2000

  mutation Types::MutationType
  query Types::QueryType

  use GraphQL::Schema::Warden
  use GraphQL::Batch
  trace_with SentryTracing

  query_analyzer Analysis::MaxNodeLimit
  query_analyzer Analysis::PrometheusMetrics

  def self.resolve_type(_type, object, _context)
    "Types::#{object.class.name}".safe_constantize
  end
end
