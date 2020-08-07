class Types::LibraryEvent < Types::BaseObject
  description 'History of user actions for a library entry.'

  field :id, ID, null: false

  field :library_entry, Types::LibraryEntry,
    null: false,
    description: 'The library entry related to this library event.'

  field :user, Types::Profile,
    null: false,
    description: 'The user who created this library event'

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media related to this library event.'

  def media
    object.anime.presence || object.manga
  end

  field :kind, Types::Enum::LibraryEventKind,
    null: false,
    description: 'The type of library event.'

  field :changed_data, Types::Map,
    null: false,
    description: 'The data that was changed for this library event.'
end
