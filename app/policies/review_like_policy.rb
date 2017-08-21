class ReviewLikePolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    return false unless user
    return false if user.unregistered?
    return false if user.blocked?(record.review.user)
    record.user == user
  end
  alias_method :destroy?, :create?

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
