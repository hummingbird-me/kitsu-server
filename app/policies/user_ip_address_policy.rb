class UserIpAddressPolicy < ApplicationPolicy
  def update?
    false
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?

  class Scope < Scope
    def resolve
      is_admin? ? scope : scope.none
    end
  end
end
