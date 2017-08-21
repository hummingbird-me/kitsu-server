class PostLikePolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def update?
    false
  end

  def create?
    return false unless user
    return false if user.unregistered?
    return false if user&.blocked?(record.post.user)
    return false if user&.has_role?(:banned)
    if group
      return false if banned_from_group?
      return false if group.closed? && !member?
    end
    is_owner?
  end
  alias_method :destroy?, :create?

  def group
    record.post.target_group
  end

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
