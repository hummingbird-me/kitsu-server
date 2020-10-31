class Mutations::Account::GrantSitePermission < Mutations::Base
  argument :account, ID,
    required: true,
    description: 'Who to grant permissions to'

  argument :permission, Types::Enum::SitePermission,
    required: true,
    description: 'The permission to grant to this user'

  field :id, ID, null: false
  field :permissions, [Types::Enum::SitePermission], null: false

  def load_account(value)
    ::User.find(value)
  end

  def authorized?
    current_user.permissions.admin?
  end

  def resolve(account:, permission:)
    res = Accounts::GrantSitePermission.call(user: account, permission: permission.to_sym)

    {
      id: res.user.id,
      permissions: res.permissions
    }
  end
end
