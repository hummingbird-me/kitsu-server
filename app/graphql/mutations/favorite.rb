class Mutations::Favorite < Mutations::Namespace
  field :create,
    mutation: Mutations::Favorite::Create,
    description: 'Add a favorite entry'
  field :delete,
    mutation: Mutations::Favorite::Delete,
    description: 'Delete a favorite entry'
end
