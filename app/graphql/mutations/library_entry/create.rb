class Mutations::LibraryEntry::Create < Mutations::Base
  argument :input,
    Inputs::LibraryEntry::Create,
    required: true,
    description: 'Create a Library Entry',
    as: :library_entry

  field :library_entry, Types::LibraryEntry, null: true

  def load_library_entry(value)
    LibraryEntry.new(value.to_h)
  end

  def authorized?(library_entry:)
    super(library_entry, :create?)
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
