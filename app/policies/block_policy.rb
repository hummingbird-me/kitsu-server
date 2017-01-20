class BlockPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  alias_method :destroy?, :create?

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
