class Types::Mutations::LibraryEntryMutation < Types::BaseObject
  field :create,
    mutation: ::Mutations::LibraryEntry::Create,
    description: 'Create a Library Entry.'

  field :update,
    mutation: ::Mutations::LibraryEntry::Update,
    description: 'Update a Library Entry.'

  field :delete,
    mutation: ::Mutations::LibraryEntry::Delete,
    description: 'Delete a Library Entry.'
end
