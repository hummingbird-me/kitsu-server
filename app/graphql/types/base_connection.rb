class Types::BaseConnection < GraphQL::Types::Relay::BaseConnection
  field :total_count, Integer,
    null: false,
    description: 'The total amount of nodes.'

  # NOTE: In 1.11.6 we used object.nodes,
  # but in 1.12.0 they added the #first to limit the amount of nodes it gets.
  # We now grab the object.items because that uses ActiveRecord direclty,
  # instead of the #nodes method in graphql (which wraps AR).
  # This will not trigger a limit based on the #first method and grab all records now.
  def total_count
    object.items.count
  end
end
