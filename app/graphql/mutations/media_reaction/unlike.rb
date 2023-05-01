class Mutations::MediaReaction::Unlike < Mutations::Base
  include FancyMutation

  description 'Remove your like from a media reaction'

  input do
    argument :media_reaction_id, ID,
      required: true,
      description: 'The reaction to remove your like from'
  end
  result Types::MediaReaction
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound

  def ready?(input:)
    authenticate!
    reaction = MediaReaction.find_by(id: input[:media_reaction_id])
    return errors << Types::Errors::NotFound.build if reaction.nil?
    true
  end

  def resolve(input:)
    MediaReactionVote.find_by(
      user_id: current_user.id,
      media_reaction_id: input[:media_reaction_id]
    )&.destroy!

    MediaReaction.find(input[:media_reaction_id])
  end
end
