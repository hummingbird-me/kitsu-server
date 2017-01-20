class PostLikePolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    return false if user&.blocked?(record.post.user)
    record.user == user
  end
  alias_method :destroy?, :create?

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
