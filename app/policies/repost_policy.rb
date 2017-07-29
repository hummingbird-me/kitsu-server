class RepostPolicy < ApplicationPolicy
  def create?
    is_owner?
  end

  def update?
    false
  end

  def destroy?
    is_owner? || is_admin?
  end
end
