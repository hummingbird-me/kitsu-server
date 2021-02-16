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
    LibraryEntry.new(value.to_h)
  end

  def authorized?(library_entry:)
    super(library_entry, :create?)
  end

  def resolve(library_entry:)
    library_entry.save!

    { library_entry: library_entry }
  end
end
