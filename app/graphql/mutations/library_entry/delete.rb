class Mutations::LibraryEntry::Delete < Mutations::Base
  argument :input,
    Types::Input::Delete,
    required: true,
    description: 'Delete Library Entry',
    as: :library_entry

  field :library_entry, Types::GenericDelete, null: true

  def load_library_entry(value)
    LibraryEntry.find(value.id)
  end

  def authorized?(library_entry:)
    super(library_entry, :destroy?)
  end

  def resolve(library_entry:)
    library_entry.destroy

    if library_entry.errors.any?
      Errors::RailsModel.graphql_error(library_entry)
    else
      {
        library_entry: { id: library_entry.id }
      }
    end
  end
end
