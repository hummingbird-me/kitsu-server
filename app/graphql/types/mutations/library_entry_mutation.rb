class Types::Mutations::LibraryEntryMutation < Types::BaseObject
  field :create,
    mutation: ::Mutations::LibraryEntry::Create,
    description: 'Create a library entry'

  field :update,
    mutation: ::Mutations::LibraryEntry::Update,
    description: 'Update a library entry'

  field :update_status_by_id,
    mutation: ::Mutations::LibraryEntry::UpdateStatusById,
    description: 'Update library entry status by id'

  field :update_status_by_media,
    mutation: ::Mutations::LibraryEntry::UpdateStatusByMedia,
    description: 'Update library entry status by media'

  field :update_progress_by_id,
    mutation: ::Mutations::LibraryEntry::UpdateProgressById,
    description: 'Update library entry progress by id'

  field :update_progress_by_media,
    mutation: ::Mutations::LibraryEntry::UpdateProgressByMedia,
    description: 'Update library entry progress by media'

  field :update_rating_by_id,
    mutation: ::Mutations::LibraryEntry::UpdateRatingById,
    description: 'Update library entry rating by id'

  field :update_rating_by_media,
    mutation: ::Mutations::LibraryEntry::UpdateRatingByMedia,
    description: 'Update library entry rating by media'

  field :delete,
    mutation: ::Mutations::LibraryEntry::Delete,
    description: 'Delete a library entry'
end
