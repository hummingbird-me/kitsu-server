class Mutations::Favorite::Delete < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Favorite::Delete,
    required: true,
    description: 'Delete a Favorite Entry',
    as: :favorite

  field :favorite, Types::GenericDelete, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_favorite(value)
    Favorite.find(value.id)
  end

  def authorized?(favorite:)
    return true if FavoritePolicy.new(context[:token], favorite).destroy?

    [false, {
      errors: [
        { message: 'Not Authorized', code: 'NotAuthorized' }
      ]
    }]
  end

  def resolve(favorite:)
    favorite.destroy!

    { favorite: { id: favorite.id } }
  end
end
