class ReviewPolicy < ApplicationPolicy
  def update?
    return true if is_admin?
    record.user == user
  end

  def create?
    record.user == user
  end

  def destroy?
    record.user == user || is_admin?
  end
end
