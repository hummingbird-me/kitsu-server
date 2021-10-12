if defined?(PrometheusExporter::Server)
  require 'graphql/tracing'

  class PrometheusCollector < GraphQL::Tracing::PrometheusTracing::GraphQLCollector
  end
end
