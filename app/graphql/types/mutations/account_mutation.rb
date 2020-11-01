class Types::Mutations::AccountMutation < Types::BaseObject
  field :set_site_permissions,
    mutation: ::Mutations::Account::SetSitePermissions,
    description: 'Set the sitewide permissions for a user'
end
