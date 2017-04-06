class GroupActionLogPolicy < ApplicationPolicy
  def update?
    false
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
