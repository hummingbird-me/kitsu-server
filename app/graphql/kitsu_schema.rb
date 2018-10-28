class KitsuSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType

  use GraphQL::Batch
  tracer SentryTracing
end
