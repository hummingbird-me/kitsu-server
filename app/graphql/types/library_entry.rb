class Types::LibraryEntry < Types::BaseObject
  description 'Information about a specific media entry for a user'

  field :id, ID, null: false

  field :profile, Types::Profile,
    null: false,
    description: 'The profile who created this library entry.',
    method: :user

  field :media, Types::Media,
    null: false,
    description: 'The media related to this library entry.'

  # field :status, Types::LibraryEntry::Status,
  #   null: false,
  #   description: ''

  # field :media_reaction, Types::MediaReaction,
  #   null: true,
  #   description: 'Reaction for this specific media'

  field :progress, Integer,
    null: false,
    description: ''

  # How do we check that user is a Staff/Mod or the user related to this library_entry?
  field :private, Boolean,
    null: false,
    description: 'If this library entry is publicly visibile from their profile, or hidden.'

  # How do we check that user is a Staff/Mod or the user related to this library_entry?
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
    description: 'When the profile started this media.'

  field :finished_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'When the profile finished this media.'

  field :progressed_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'unsure'
end
