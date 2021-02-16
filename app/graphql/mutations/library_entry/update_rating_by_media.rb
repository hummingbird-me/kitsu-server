class Mutations::LibraryEntry::UpdateRatingByMedia < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::LibraryEntry::UpdateRatingByMedia,
    required: true,
    description: 'Update library entry rating by media',
    as: :library_entry

  field :library_entry, Types::LibraryEntry, null: true
  field :errors, [Types::Interface::Error], null: true

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
    library_entry.save!

    { library_entry: library_entry }
  end
end
