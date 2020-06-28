class Mutations::LibraryEntry::Delete < Mutations::BaseCrudMutation
  argument :input,
    Inputs::LibraryEntry::Delete,
    required: true,
    description: 'Delete Library Entry'

  field :library_entry, Types::GenericDelete, null: true
end
