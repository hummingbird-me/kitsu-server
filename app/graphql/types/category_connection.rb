class Types::CategoryConnection < Types::BaseConnection
  edge_type(Types::CategoryEdge)

  def categories
    AssociationLoader.for(object.class, :categories).load(object)
  end

  def children
    AssociationLoader.for(object.class, :children).load(object)
  end
end
