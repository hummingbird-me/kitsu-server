class Types::Mutations::LibraryEntryMutation < Types::BaseObject
  field :create,
    mutation: ::Mutations::LibraryEntry::Create,
    description: 'Create a library entry'

  field :update,
    mutation: ::Mutations::LibraryEntry::Update,
    description: 'Update a library entry'

  field :update_status_by_id,
    mutation: ::Mutations::LibraryEntry::UpdateStatusById,
    description: 'Update a library entry status by id'

  field :delete,
    mutation: ::Mutations::LibraryEntry::Delete,
    description: 'Delete a library entry'
end
