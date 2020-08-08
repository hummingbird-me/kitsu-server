class Types::Mutations::AnimeMutation < Types::BaseObject
  field :create,
    mutation: ::Mutations::Anime::Create,
    description: 'Create an Anime.'

  field :update,
    mutation: ::Mutations::Anime::Update,
    description: 'Update an Anime.'

  field :delete,
    mutation: ::Mutations::Anime::Delete,
    description: 'Delete an Anime.'
end
