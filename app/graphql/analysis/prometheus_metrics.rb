# frozen_string_literal: true

require 'graphql/metrics'

module Analyzer
  class PrometheusMetrics < GraphQL::Metrics::Analyzer
    # graphql_query_duration_seconds{operation_type,operation_name}
    GRAPHQL_QUERY_DURATION_SECONDS = $prometheus.register(
      :summary,
      'graphql_query_duration_seconds',
      'Time spent in GraphQL queries'
    )

    # graphql_query_requests_total{operation_type,operation_name}
    GRAPHQL_QUERY_REQUESTS_TOTAL = $prometheus.register(
      :counter,
      'graphql_query_requests_total',
      'Number of GraphQL queries'
    )

    # graphql_field_duration_seconds{object,field}
    GRAPHQL_FIELD_DURATION_SECONDS = $prometheus.register(
      :summary,
      'graphql_field_duration_seconds',
      'Time spent in GraphQL fields'
    )

    # graphql_field_requests_total{object,field}
    GRAPHQL_FIELD_REQUESTS_TOTAL = $prometheus.register(
      :counter,
      'graphql_field_requests_total',
      'Number of requests for a given field'
    )

    # graphql_argument_duration_seconds{object,field,argument}
    GRAPHQL_ARGUMENT_REQUESTS_TOTAL = $prometheus.register(
      :counter,
      'graphql_argument_requests_total',
      'Number of requests using a given argument'
    )

    def query_extracted(metrics)
      GRAPHQL_QUERY_REQUESTS_TOTAL.observe(1,
        operation_type: metrics[:operation_type],
        operation_name: metrics[:operation_name])

      GRAPHQL_QUERY_DURATION_SECONDS.observe(metrics[:query_duration],
        operation_type: metrics[:operation_type],
        operation_name: metrics[:operation_name])
    end

    def field_extracted(metrics)
      GRAPHQL_FIELD_REQUESTS_TOTAL.observe(1,
        type: metrics[:parent_type_name],
        field: metrics[:field_name])
      GRAPHQL_FIELD_DURATION_SECONDS.observe(
        metrics.dig(:resolver_timings, :duration),
        type: metrics[:parent_type_name],
        field: metrics[:field_name]
      )
    end

    def argument_extracted(metrics)
      GRAPHQL_ARGUMENT_REQUESTS_TOTAL.observe(1,
        type: metrics[:grandparent_type_name],
        field: metrics[:parent_name],
        argument: metrics[:argument_name])
    end
  end
end
