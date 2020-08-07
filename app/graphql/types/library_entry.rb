class Types::LibraryEntry < Types::BaseObject
  description 'Information about a specific media entry for a user'

  field :id, ID, null: false

  field :user, Types::Profile,
    null: false,
    description: 'The user who created this library entry.'

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media related to this library entry.'

  field :status, Types::Enum::LibraryEntryStatus,
    null: false,
    description: ''

  field :reaction, Types::MediaReaction,
    null: true,
    description: 'The reaction based on the media of this library entry.'

  field :progress, Integer,
    null: false,
    description: 'The number of episodes/chapters this user has watched/read'

  field :private, Boolean,
    null: false,
    description: 'If this library entry is publicly visibile from their profile, or hidden.'

  field :notes, String,
    null: true,
    description: 'Notes left by the profile related to this library entry.'

  field :reconsume_count, Integer,
    null: false,
    description: 'Amount of times this media has been rewatched.'

  field :reconsuming, Boolean,
    null: false,
    description: 'If the profile is currently rewatching this media.'

  field :volumes_owned, Integer,
    null: false,
    description: 'Volumes that the profile owns (physically or digital).'

  field :nsfw, Boolean,
    null: false,
    description: 'If the media related to the library entry is Not-Safe-for-Work.'

  field :rating, Integer,
    null: true,
    description: 'How much you enjoyed this media (lower meaning not liking).'

  field :started_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'When the user started this media.'

  field :finished_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'When the user finished this media.'

  field :progressed_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'When the user last watched an episode or read a chapter of this media.'

  field :library_events, Types::LibraryEvent.connection_type,
    null: true,
    description: 'History of user actions for this library entry.'

  def library_events
    AssociationLoader.for(object.class, :library_events).scope(object)
  end
end
