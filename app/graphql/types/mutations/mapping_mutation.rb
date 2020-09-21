class Types::Mutations::MappingMutation < Types::BaseObject
  field :create,
    mutation: ::Mutations::Mapping::Create,
    description: 'Create a Mapping'

  field :update,
    mutation: ::Mutations::Mapping::Update,
    description: 'Update a Mapping'

  field :delete,
    mutation: ::Mutations::Mapping::Delete,
    description: 'Delete a Mapping'
end
