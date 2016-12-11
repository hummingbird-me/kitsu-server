class ReviewPolicy < ApplicationPolicy
  alias_method :create?, :is_owner?

  def update?
    is_owner? || is_admin?
  end

  alias_method :destroy?, :update?

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
