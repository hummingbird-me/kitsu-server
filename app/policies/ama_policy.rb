class AMAPolicy < ApplicationPolicy
  def update?
    record.author == user || is_admin?
  end

  def destroy?
    record.author == user || is_admin?
  end

  def create?
    is_admin?
  end
end
