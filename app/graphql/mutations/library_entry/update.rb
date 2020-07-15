class Mutations::LibraryEntry::Update < Mutations::Base
  argument :input,
    Inputs::LibraryEntry::Update,
    required: true,
    description: 'Update Library Entry',
    as: :library_entry

  field :library_entry, Types::LibraryEntry, null: true

  # NOTE: https://github.com/rmosolgo/graphql-ruby/issues/1733
  # NOTE: https://www.rubydoc.info/github/rmosolgo/graphql-ruby/GraphQL/Schema/Resolver#argument-class_method
  # the argument loads: ... is not required, it is called every time.
  def load_library_entry(value)
    LibraryEntry.find(value.id)
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
