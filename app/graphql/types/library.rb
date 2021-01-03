class Types::Library < Types::BaseObject
  description 'The user library filterable by media_type and status'

  field :random_media, Types::Interface::Media, null: true do
    description 'Random anime or manga from this library'

    argument :media_type, Types::Enum::MediaType, required: true
    argument :status, [Types::Enum::LibraryEntryStatus], required: true
  end

  def random_media(media_type:, status:)
    library_entries(media_type: media_type, status: status).then do |library_entries|
      library_entries.order(Arel.sql('RANDOM()')).first&.media
    end
  end

  field :all, Types::LibraryEntry.connection_type, null: false do
    description 'All Library Entries for a specific Media'
    argument :media_type, Types::Enum::MediaType, required: true
    argument :status, [Types::Enum::LibraryEntryStatus], required: false
  end

  def all(media_type:, status: nil)
    library_entries(media_type: media_type, status: status)
  end

  field :current, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries for a specific Media filtered by the current status'
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def current(media_type:)
    library_entries(media_type: media_type, status: :current)
  end

  field :planned, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries for a specific Media filtered by the planned status'
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def planned(media_type:)
    library_entries(media_type: media_type, status: :planned)
  end

  field :completed, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries for a specific Media filtered by the completed status'
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def completed(media_type:)
    library_entries(media_type: media_type, status: :completed)
  end

  field :on_hold, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries for a specific Media filtered by the on_hold status'
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def on_hold(media_type:)
    library_entries(media_type: media_type, status: :on_hold)
  end

  field :dropped, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries for a specific Media filtered by the dropped status'
    argument :media_type, Types::Enum::MediaType, required: true
  end

  def dropped(media_type:)
    library_entries(media_type: media_type, status: :dropped)
  end

  def library_entries(media_type: nil, status: nil)
    query = { media_type: media_type, status: status }.compact
    AssociationLoader.for(
      object.class,
      :library_entries,
      token: context[:token]
    ).scope(object).then do |library_entries|
      library_entries.where(query)
    end
  end
end
