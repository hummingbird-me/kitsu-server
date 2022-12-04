class ReportPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create?
    return false unless user
    return false if user.has_role?(:banned)
    is_owner?
  end

  def update?
    return false unless user
    return false if user.has_role?(:banned)
    is_owner? || can_administrate?
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      if can_administrate?
        scope
      else
        scope.where(user: user)
      end
    end
  end
end
