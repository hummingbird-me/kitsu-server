class Mutations::Block < Mutations::Namespace
  field :create,
    mutation: Mutations::Block::Create,
    description: 'Create a Block entry.'

  field :delete,
    mutation: Mutations::Block::Delete,
    description: 'Delete a Block entry.'
end
