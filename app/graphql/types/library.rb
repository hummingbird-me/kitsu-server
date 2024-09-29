class Types::Library < Types::BaseObject
  description 'The user library'

  field :random_media, Types::Interface::Media, null: true do
    description 'Random anime or manga from this library'

    argument :media_type, Types::Enum::MediaType, required: true
    argument :status, [Types::Enum::LibraryEntryStatus], required: true
  end

  def random_media(media_type:, status:)
    LibraryEntry.where(media_type:, status:).order(Arel.sql('RANDOM()')).first&.media
  end

  field :all, Types::LibraryEntry.connection_type, null: false do
    description 'All Library Entries'
    argument :media_type, Types::Enum::MediaType, required: false
    argument :status, [Types::Enum::LibraryEntryStatus], required: false
    argument :sort, Loaders::LibraryEntriesLoader.sort_argument, required: false
  end

  def all(media_type: nil, status: nil, sort: [{ on: :created_at, direction: :desc }])
    Loaders::LibraryEntriesLoader.connection_for({
      find_by: :user_id,
      sort:,
      where: { media_type:, status: }.compact
    }, object.id)
  end

  field :current, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries with the current status'
    argument :media_type, Types::Enum::MediaType, required: false
    argument :sort, Loaders::LibraryEntriesLoader.sort_argument, required: false
  end

  def current(media_type: nil, sort: [{ on: :created_at, direction: :desc }])
    all(media_type:, sort:, status: :current)
  end

  field :planned, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries with the planned status'
    argument :media_type, Types::Enum::MediaType, required: false
    argument :sort, Loaders::LibraryEntriesLoader.sort_argument, required: false
  end

  def planned(media_type: nil, sort: [{ on: :created_at, direction: :desc }])
    all(media_type:, sort:, status: :planned)
  end

  field :completed, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries with the completed status'
    argument :media_type, Types::Enum::MediaType, required: false
    argument :sort, Loaders::LibraryEntriesLoader.sort_argument, required: false
  end

  def completed(media_type: nil, sort: [{ on: :created_at, direction: :desc }])
    all(media_type:, sort:, status: :completed)
  end

  field :on_hold, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries with the on_hold status'
    argument :media_type, Types::Enum::MediaType, required: false
    argument :sort, Loaders::LibraryEntriesLoader.sort_argument, required: false
  end

  def on_hold(media_type: nil, sort: [{ on: :created_at, direction: :desc }])
    all(media_type:, sort:, status: :on_hold)
  end

  field :dropped, Types::LibraryEntry.connection_type, null: false do
    description 'Library Entries with the dropped status'
    argument :media_type, Types::Enum::MediaType, required: false
    argument :sort, Loaders::LibraryEntriesLoader.sort_argument, required: false
  end

  def dropped(media_type: nil, sort: [{ on: :created_at, direction: :desc }])
    all(media_type:, sort:, status: :dropped)
  end
end
