# frozen_string_literal: true

class Mutations::MediaReaction::Like < Mutations::Base
  include RateLimitedMutation
  include FancyMutation

  description 'Like a media reaction'

  rate_limit do
    limit 60, per: 1.hour
  end

  input do
    argument :media_reaction_id, ID,
      required: true,
      description: 'The reaction to like'
  end
  result Types::MediaReaction
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound

  def ready?(media_reaction_id:)
    authenticate!
    @reaction = MediaReaction.find_by(id: media_reaction_id)
    return errors << Types::Errors::NotFound.build if @reaction.nil?
    authorize!(@reaction, :like?)
    true
  end

  def resolve(**)
    MediaReactionVote.find_or_create_by!(
      user: current_user,
      media_reaction: @reaction
    )
    @reaction
  end
end
