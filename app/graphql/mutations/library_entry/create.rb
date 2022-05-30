class Mutations::LibraryEntry::Create < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::LibraryEntry::Create,
    required: true,
    description: 'Create a Library Entry',
    as: :library_entry

  field :library_entry, Types::LibraryEntry, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_library_entry(value)
    LibraryEntry.new(value.to_model)
  end

  def authorized?(library_entry:)
    return true if LibraryEntryPolicy.new(context[:token], library_entry).create?

    [false, {
      errors: [
        { message: 'Not Authorized', code: 'NotAuthorized' }
      ]
    }]
  end

  def resolve(library_entry:)
    library_entry.save!

    { library_entry: library_entry }
  end
end
