class AMAPolicy < ApplicationPolicy
  def update?
    record.author == user
  end

  def destroy?
    record.author == user || is_admin?
  end

  alias_method :create?, :update?
end
