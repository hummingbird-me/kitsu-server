class MediaReactionPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create?
    return false unless user
    return false if user.has_role?(:banned)
    record.user == user
  end
  alias_method :update?, :create?

  def destroy?
    record.try(:user) == user || can_administrate?
  end

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
