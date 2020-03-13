class KitsuSchema < GraphQL::Schema
  default_max_page_size 100

  mutation Types::MutationType
  query Types::QueryType

  use GraphQL::Batch
  tracer SentryTracing

  def self.resolve_type(_type, object, _context)
    "Types::#{object.class.name}".safe_constantize
  end
end
