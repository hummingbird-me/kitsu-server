class Types::NoltToken < Types::BaseObject
  description 'Single sign-on token for Nolt'

  field :token, String, null: false, description: 'The generated JWT'
end
