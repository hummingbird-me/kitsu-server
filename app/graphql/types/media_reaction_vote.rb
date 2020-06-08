class Types::MediaReactionVote < Types::BaseObject
  description 'The author who upvoted a specific media reaction.'

  field :id, ID, null: false

  field :author, Types::Profile,
    null: false,
    description: 'Profile who upvoted this media reaction.',
    method: :user

  field :media_reaction, Types::MediaReaction,
    null: false,
    description: 'Reaction that was upvoted.'
end
