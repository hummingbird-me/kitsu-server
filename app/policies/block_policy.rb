class BlockPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create?
    return false if record == Block
    record.user == user
  end

  def destroy?
    record.try(:user) == user || can_administrate?
  end

  class Scope < Scope
    def resolve
      return scope if can_administrate?
      scope.where(user: user)
    end
  end
end
