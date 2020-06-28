class Mutations::LibraryEntry::Create < Mutations::BaseCrudMutation
  argument :input,
    Inputs::LibraryEntry::Create,
    required: true,
    description: 'Create Library Entry'

  field :library_entry, Types::LibraryEntry, null: true
end
