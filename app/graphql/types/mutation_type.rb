class Types::MutationType < Types::BaseObject
  field :pro, Types::ProMutation, null: false

  field :create_anime,
    mutation: Mutations::Anime::Create,
    description: 'Create an Anime.'

  field :update_anime,
    mutation: Mutations::Anime::Update,
    description: 'Update an Anime.'

  field :delete_anime,
    mutation: Mutations::Anime::Delete,
    description: 'Delete an Anime.'

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
