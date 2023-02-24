class Mutations::Post < Mutations::Namespace
  field :lock,
    mutation: Mutations::Post::Lock,
    description: 'Lock a Post.'

  field :unlock,
    mutation: Mutations::Post::Unlock,
    description: 'Unlock a Post.'

  field :create,
    mutation: Mutations::Post::Create,
    description: 'Create a Post.'
end
