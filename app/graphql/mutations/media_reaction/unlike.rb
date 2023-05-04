# frozen_string_literal: true

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

  def ready?(media_reaction_id:)
    authenticate!
    @reaction = MediaReaction.find_by(id: media_reaction_id)
    return errors << Types::Errors::NotFound.build if @reaction.nil?
    true
  end

  def resolve(**)
    MediaReactionVote.find_by(
      user: current_user,
      media_reaction: @reaction
    )&.destroy!

    @reaction
  end
end
