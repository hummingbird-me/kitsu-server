class Types::Category::ChildConnection < Types::BaseConnection
  edge_type(Types::Category::ChildEdge)

  field :total_count, Integer,
    null: false,
    description: 'The total amount of children for this category'

  def total_count
    object.nodes.count
  end
end
