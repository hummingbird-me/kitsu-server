module Accounts
  class SetSitePermissions < Action
    class UnknownPermissions < StandardError; end

    parameter :user, load: User, required: true
    parameter :permissions, required: true

    def call
      sym_permissions = permissions.map(&:to_sym)

      unknown_permissions = sym_permissions - User.permissions.keys
      raise UnknownPermissions, unknown_permissions if unknown_permissions.present?

      user.permissions = sym_permissions
      user.save!

      { user: user, permissions: user.permissions }
    end
  end
end
