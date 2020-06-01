class Types::BaseConnection < GraphQL::Types::Relay::BaseConnection
  field :total_count, Integer,
    null: false,
    description: 'The total amount of nodes.'

  def total_count
    object.nodes.count
  end
end
