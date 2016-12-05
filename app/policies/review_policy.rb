class ReviewPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def update?
    record.user == user || is_admin?
  end
  alias_method :destroy?, :update?

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
