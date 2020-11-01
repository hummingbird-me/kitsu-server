class Types::Input::Account::SetSitePermissions < Types::Input::Base
  argument :account_id, ID,
    required: true,
    description: 'Who to grant permissions to'

  argument :permissions, [Types::Enum::SitePermission],
    required: true,
    description: 'The permissions to set for this user'
end
