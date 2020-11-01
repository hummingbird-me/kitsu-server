class Mutations::Account::SetSitePermissions < Mutations::Base
  argument :input, Types::Input::Account::SetSitePermissions,
    required: true

  field :account, Types::Account, null: false

  def authorized?
    current_user.permissions.admin?
  end

  def resolve(input:)
    account = User.find(input[:account_id])
    permissions = input[:permissions].map(&:to_sym)

    res = Accounts::SetSitePermissions.call(user: account, permissions: permissions)

    { account: res.user }
  end
end
