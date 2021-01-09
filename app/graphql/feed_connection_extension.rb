class FeedConnectionExtension < GraphQL::Schema::Field::ConnectionExtension
  def apply
    field.argument :first, 'Int', 'Returns the specific amount of elements', required: true
    field.argument :after, 'String', 'Returns the elements in the list that come after the specified cursor.', required: false
  end

  def resolve(object:, arguments:, context:)
    next_args = arguments.dup

    yield(object, next_args)
  end
end
