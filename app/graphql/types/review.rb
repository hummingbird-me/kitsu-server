class Types::Review < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A media review made by a user'

  field :id, ID, null: false

  field :author, Types::Profile,
    null: false,
    description: 'The author who wrote this review.',
    method: :user

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media related to this review.'

  field :library_entry, Types::LibraryEntry,
    null: false,
    description: 'The library entry related to this review.'

  field :progress, Integer,
    null: false,
    description: 'When this review was written based on media progress.'

  field :rating, Integer,
    null: false,
    description: 'The user rating for this media'

  field :content, String,
    null: false,
    description: 'The review data'

  field :formatted_content, String,
    null: false,
    description: 'The review data formatted'

  field :source, String,
    null: false,
    description: 'Potentially migrated over from hummingbird.'

  field :is_spoiler, Boolean,
    null: false,
    description: 'Does this review contain spoilers from the media',
    method: :spoiler

  field :deleted_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'When this review was deleted'

  field :likes, Types::Profile.connection_type,
    null: false,
    description: 'Users who liked this review'

  def likes
    AssociationLoader.for(object.class, :likes, policy: :review_like)
                     .scope(object).then do |likes|
      RecordLoader.for(User, token: context[:token]).load_many(likes.pluck(:user_id))
    end
  end
end
