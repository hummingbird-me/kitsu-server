module Accounts
  class RevokeSitePermission < Action
    class UnknownPermission < StandardError; end

    parameter :user, load: User, required: true
    parameter :permission, required: true

    def call
      raise UnknownPermission unless User.permissions.keys.include?(permission)

      user.permissions.unset(permission)
      user.save!

      { user: user, permissions: user.permissions }
    end
  end
end
