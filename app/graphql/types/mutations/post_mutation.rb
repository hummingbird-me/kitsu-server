class Types::Mutations::PostMutation < Types::BaseObject
  field :lock,
    mutation: ::Mutations::Post::LockPost,
    description: 'Lock a Post.'

  field :unlock,
    mutation: ::Mutations::Post::UnlockPost,
    description: 'Unlock a Post.'
end
