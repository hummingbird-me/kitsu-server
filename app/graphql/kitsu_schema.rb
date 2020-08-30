require_dependency 'custom_errors'
require_dependency 'monkey_patching/custom_scoped_type_complexity'
require_dependency 'monkey_patching/custom_max_query_complexity'

class KitsuSchema < GraphQL::Schema
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST
  use GraphQL::Execution::Errors

  default_max_page_size 100

  mutation Types::MutationType
  query Types::QueryType

  use GraphQL::Batch
  tracer SentryTracing

  def self.resolve_type(_type, object, _context)
    "Types::#{object.class.name}".safe_constantize
  end
end
