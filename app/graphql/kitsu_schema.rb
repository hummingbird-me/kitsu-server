class KitsuSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType

  use GraphQL::Batch
  tracer SentryTracing

  def self.resolve_type(type, object, context)
    "Types::#{object.class.name}".safe_constantize
  end
end
