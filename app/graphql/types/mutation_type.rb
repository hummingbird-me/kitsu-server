class Types::MutationType < Types::BaseObject
  field :ping, String,
    null: false,
    description: 'Fixes GraphQL; does nothing else.'

  # Apply a changeset to a node
  field :apply_changeset, mutation: Mutations::ApplyChangeset

  def ping
    'pong'
  end
end
