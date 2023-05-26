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
    Types::Errors::NotFound

  def ready?(favorite_id:, **)
    authenticate!
    @favorite = Favorite.find(favorite_id)
    authorize!(@favorite, :destroy?)
    true
  end

  def resolve(**)
    @favorite.destroy!
    @favorite
  end
end
