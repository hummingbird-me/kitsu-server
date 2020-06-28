class Mutations::LibraryEntry::Update < Mutations::BaseCrudMutation
  argument :input,
    Inputs::LibraryEntry::Update,
    required: true,
    description: 'Update Library Entry'

  field :library_entry, Types::LibraryEntry, null: true
end
