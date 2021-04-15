class Types::Input::GenericDelete < Types::Input::Base
  graphql_name 'GenericDeleteInput'

  argument :id, ID, required: true
end
