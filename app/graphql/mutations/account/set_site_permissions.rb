class Mutations::Account::SetSitePermissions < Mutations::Base
  argument :input, Types::Input::Account::SetSitePermissions,
    required: true

  field :account, Types::Account, null: false

  def authorized?(input:)
    super(input.account, :set_site_permissions?)
  end

  def resolve(input:)
    permissions = input.permissions.map(&:to_sym)

    res = Accounts::SetSitePermissions.call(
      user: input.account,
      permissions: permissions
    )

    { account: res.user }
  end
end
