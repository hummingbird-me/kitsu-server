class Mutations::LibraryEntry::Delete < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete Library Entry',
    as: :library_entry

  field :library_entry, Types::GenericDelete, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_library_entry(value)
    LibraryEntry.find(value.id)
  end

  def authorized?(library_entry:)
    return true if LibraryEntryPolicy.new(context[:token], library_entry).destroy?

    [false, {
      errors: [
        { message: 'Not Authorized', code: 'NotAuthorized' }
      ]
    }]
  end

  def resolve(library_entry:)
    library_entry.destroy!

    { library_entry: { id: library_entry.id } }
  end
end
