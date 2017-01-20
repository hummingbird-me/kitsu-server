class UserRolePolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    is_admin?
  end
  alias_method :destroy?, :create?
end
