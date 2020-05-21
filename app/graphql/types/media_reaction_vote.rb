class Types::MediaReactionVote < Types::BaseObject
  description 'The profile who upvoted a specific media reaction.'

  field :id, ID, null: false

  field :profile, Types::Profile,
    null: false,
    description: 'Profile who upvoted this media reaction.',
    method: :user

  field :media_reaction, Types::MediaReaction,
    null: false,
    description: 'Reaction that was upvoted.'
end
