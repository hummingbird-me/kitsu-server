class Types::Mutations::EpisodeMutation < Types::BaseObject
  field :create,
    mutation: ::Mutations::Episode::Create,
    description: 'Create an Episode.'

  field :update,
    mutation: ::Mutations::Episode::Update,
    description: 'Update an Episode.'

  field :delete,
    mutation: ::Mutations::Episode::Delete,
    description: 'Delete an Episode.'
end
