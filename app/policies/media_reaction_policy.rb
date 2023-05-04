class MediaReactionPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create?
    return false unless user
    return false if user.has_role?(:banned)
    record.user == user
  end
  alias_method :update?, :create?

  def like?
    return false unless user
    return false if user == record.user
    return false if user.has_role?(:banned)
    return false if is_blocked?(user, record.user)

    true
  end

  def destroy?
    record.try(:user) == user || can_administrate?
  end

  class Scope < Scope
    def resolve
      scope
        .where.not(user_id: blocked_users)
        .where(hidden_at: nil).or(scope.where(user_id: user).where.not(hidden_at: nil))
    end
  end
end
