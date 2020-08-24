class Mutations::LibraryEntry::UpdateStatusByMedia < Mutations::Base
  argument :input,
    Types::Input::LibraryEntry::UpdateStatusByMedia,
    required: true,
    description: 'Update library entry status by media',
    as: :library_entry

  field :library_entry, Types::LibraryEntry, null: true

  def load_library_entry(value)
    library_entry = ::LibraryEntry.find_by!(
      user_id: current_user.id,
      media_id: value.media_id,
      media_type: value.media_type
    )
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
