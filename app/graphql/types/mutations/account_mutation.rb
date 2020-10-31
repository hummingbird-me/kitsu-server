class Types::Mutations::AccountMutation < Types::BaseObject
  field :grant_site_permission,
    mutation: ::Mutations::Account::GrantSitePermission,
    description: 'Grant a sitewide permission to a user'
  field :revoke_site_permission,
    mutation: ::Mutations::Account::RevokeSitePermission,
    description: 'Revoke a sitewide permission for a user'
end
