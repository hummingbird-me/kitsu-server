class UserRolePolicy < ApplicationPolicy
  administrated_by :community_mod

  def update?
    false
  end

  def create?
    can_administrate?
  end
  alias_method :destroy?, :create?
end
