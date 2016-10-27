class LinkedProfilePolicy < ApplicationPolicy
  def show?
    record.user == user || user.has_role?(:admin)
  end

  def update?
    record.user == user || is_admin?
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?
end
