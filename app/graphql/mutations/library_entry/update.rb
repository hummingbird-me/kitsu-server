class Mutations::LibraryEntry::Update < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::LibraryEntry::Update,
    required: true,
    description: 'Update Library Entry',
    as: :library_entry

  field :library_entry, Types::LibraryEntry, null: true
  field :errors, [Types::Interface::Error], null: true

  # NOTE: https://github.com/rmosolgo/graphql-ruby/issues/1733
  # NOTE: https://www.rubydoc.info/github/rmosolgo/graphql-ruby/GraphQL/Schema/Resolver#argument-class_method
  # the argument loads: ... is not required, it is called every time.
  # you may pass back a hash also, which will be injected in the argument
  # i.e: { record: library_entry, value: value }
  def load_library_entry(value)
    library_entry = LibraryEntry.find(value.id)
    library_entry.assign_attributes(value.to_h)
    library_entry
  end

  def authorized?(library_entry:)
    return true if LibraryEntryPolicy.new(context[:token], library_entry).update?

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
