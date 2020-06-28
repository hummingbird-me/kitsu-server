class Types::MutationType < Types::BaseObject
  field :pro, Types::ProMutation, null: false
  field :anime, Types::AnimeMutation, null: false
  # field :library_entry, Types::LibraryEntryMutation, null: false

  field :create_library_entry,
    mutation: Mutations::LibraryEntry::Create,
    description: 'Create a Library Entry'

  field :update_library_entry,
    mutation: Mutations::LibraryEntry::Update,
    description: 'Update a Library Entry'

  field :delete_library_entry,
    mutation: Mutations::LibraryEntry::Delete,
    description: 'Delete a Library Entry'
end
