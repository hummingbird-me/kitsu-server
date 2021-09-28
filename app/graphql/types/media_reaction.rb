class Types::MediaReaction < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A simple review that is 140 characters long expressing how you felt about a media'

  field :id, ID, null: false

  field :author, Types::Profile,
    null: false,
    description: 'The author who wrote this reaction.',
    method: :user

  def author
    RecordLoader.for(User, token: context[:token]).load(object.user_id)
  end

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media related to this reaction.'

  field :library_entry, Types::LibraryEntry,
    null: false,
    description: 'The library entry related to this reaction.'

  field :progress, Integer,
    null: false,
    description: 'When this media reaction was written based on media progress.'

  field :reaction, String,
    null: false,
    description: 'The reaction text related to a media.'

  field :likes, Types::Profile.connection_type, null: false do
    description 'Users that have liked this reaction'
    argument :sort, Loaders::MediaReactionVotesLoader.sort_argument, required: false
  end

  def likes(sort: [{ on: :created_at, direction: :desc }])
    Loaders::MediaReactionVotesLoader.connection_for({
      find_by: :media_reaction_id,
      sort: sort
    }, object.id).then do |likes|
      RecordLoader.for(User, token: context[:token]).load_many(likes.map(&:user_id))
    end
  end
end
