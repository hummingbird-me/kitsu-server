class GroupTicketMessagePolicy < ApplicationPolicy
  def create?
    policy_for(record.ticket).update?
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
