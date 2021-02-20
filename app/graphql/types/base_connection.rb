class Types::BaseConnection < GraphQL::Types::Relay::BaseConnection
  field :total_count, Integer,
    null: false,
    description: 'The total amount of nodes.'

  # NOTE: In graphql 1.11.6 object.nodes was not limited by first. Now we use AR directly.
  def total_count
    object.items.count
  end
end
