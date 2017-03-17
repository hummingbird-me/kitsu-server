class BlockPolicy < ApplicationPolicy
  def create?
    return false if record == Block
    record.user == user
  end

  def destroy?
    record.try(:user) == user || is_admin?
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
