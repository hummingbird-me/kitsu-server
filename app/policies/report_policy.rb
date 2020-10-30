class ReportPolicy < ApplicationPolicy
  administrated_by :community_mod

  alias_method :create?, :is_owner?

  def update?
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
