class Mutations::Favorite::Create < Mutations::Base
    prepend RescueValidationErrors
  
    argument :input,
      Types::Input::Favorite::Create,
      required: true,
      description: 'Create a Favorite Entry',
      as: :favorite
  
    field :favorite, Types::Favorite, null: true
    field :errors, [Types::Interface::Error], null: true
  
    def load_favorite(value)
      Favorite.new(value.to_model)
    end
  
    def authorized?(favorite:)
      return true if FavoritePolicy.new(context[:token], favorite).create?
  
      [false, {
        errors: [
          { message: 'Not Authorized', code: 'NotAuthorized' }
        ]
      }]
    end
  
    def resolve(favorite:)
      favorite.save!
  
      { favorite: favorite }
    end
  end
  