# frozen_string_literal: true

class Mutations::MediaReaction::Delete < Mutations::Base
  include FancyMutation

  description 'Delete a mutation'

  input do
    argument :media_reaction_id, ID,
      required: true,
      description: 'The reaction to delete'
  end
  result Types::MediaReaction
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound

  def ready?(media_reaction_id:)
    authenticate!
    @reaction = MediaReaction.find_by(id: media_reaction_id)
    return errors << Types::Errors::NotFound.build if @reaction.nil?
    authorize!(@reaction, :destroy?)
    true
  end

  def resolve(**)
    @reaction.destroy!
    @reaction
  end
end
