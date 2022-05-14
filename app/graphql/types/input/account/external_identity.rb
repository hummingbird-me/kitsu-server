class Types::Input::Account::ExternalIdentity < Types::Input::Base
  argument :provider, Types::Enum::ExternalIdentityProvider, required: true
  argument :id, String, required: true
end
