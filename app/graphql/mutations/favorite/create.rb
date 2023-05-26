# frozen_string_literal: true

class Mutations::Favorite::Create < Mutations::Base
  include FancyMutation

  description 'Add a favorite entry.'

  input do
    argument :item_id, ID,
      required: true,
      description: 'The id of the entry'
    argument :item_type,
      Types::Enum::FavoriteItem,
      required: true,
      description: 'The type of the entry.'
  end
  result Types::Favorite
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotFound

  def ready?(**)
    authenticate!
    true
  end

  def resolve(item_id:, item_type:, **)
    @favorite = Favorite.new(
      item_type:,
      item_id:,
      user_id: current_user.id
    )
    authorize!(@favorite, :create?)
    @favorite.tap(&:save!)
  end
end
