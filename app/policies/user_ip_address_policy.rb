class UserIpAddressPolicy < ApplicationPolicy
  administrated_by :community_mod

  def update?
    false
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?

  class Scope < Scope
    def resolve
      can_administrate? ? scope : scope.none
    end
  end
end
