class Mutations::LibraryEntry::UpdateStatusById < Mutations::Base
  argument :input,
    Types::Input::LibraryEntry::UpdateStatusById,
    required: true,
    description: 'Update library entry status by id',
    as: :library_entry

  field :library_entry, Types::LibraryEntry, null: true

  def load_library_entry(value)
    library_entry = ::LibraryEntry.find(value.id)
    library_entry.assign_attributes(value.to_h)
    library_entry
  end

  def authorized?(library_entry:)
    super(library_entry, :update?)
  end

  def resolve(library_entry:)
    library_entry.save

    if library_entry.errors.any?
      Errors::RailsModel.graphql_error(library_entry)
    else
      {
        library_entry: library_entry
      }
    end
  end
end
