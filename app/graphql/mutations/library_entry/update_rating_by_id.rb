class Mutations::LibraryEntry::UpdateRatingById < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::LibraryEntry::UpdateRatingById,
    required: true,
    description: 'Update library entry rating by id',
    as: :library_entry

  field :library_entry, Types::LibraryEntry, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_library_entry(value)
    library_entry = ::LibraryEntry.find(value.id)
    library_entry.assign_attributes(value.to_h)
    library_entry
  end

  def authorized?(library_entry:)
    super(library_entry, :update?)
  end

  def resolve(library_entry:)
    library_entry.save!

    { library_entry: library_entry }
  end
end
