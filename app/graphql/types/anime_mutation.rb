class Types::AnimeMutation < Types::BaseObject
  field :update, mutation: Mutations::Anime::Update, description: 'Update an Anime'
  field :create, mutation: Mutations::Anime::Create, description: 'Create an Anime'
  field :delete, mutation: Mutations::Anime::Delete, description: 'Delete an Anime'
end
