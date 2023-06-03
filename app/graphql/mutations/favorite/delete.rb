# frozen_string_literal: true

class Mutations::Favorite::Delete < Mutations::Base
  include FancyMutation

  description 'Delete a favorite entry.'

  input do
    argument :favorite_id, ID,
      required: true,
      description: 'The id of the favorite entry.'
  end
  result Types::Favorite
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotFound,
    Types::Errors::NotAuthorized

  def ready?(favorite_id:, **)
    authenticate!
    @favorite = Favorite.find_by(id: favorite_id)
    return errors << Types::Errors::NotFound.build if @favorite.nil?
    authorize!(@favorite, :destroy?)
    true
  end

  def resolve(**)
    @favorite.destroy!
    @favorite
  end
end
