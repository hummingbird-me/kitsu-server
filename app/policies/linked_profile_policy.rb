class LinkedProfilePolicy < ApplicationPolicy
  def show?
    record.user == user || record.public? || is_admin?
  end

  def update?
    record.user == user || is_admin?
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?
end
