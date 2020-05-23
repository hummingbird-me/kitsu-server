class Types::MediaReactionVoteConnection < Types::BaseConnection
  edge_type(Types::MediaReactionVoteEdge)

  def votes
    AssociationLoader.for(object.class, :votes).load(object)
  end
end
