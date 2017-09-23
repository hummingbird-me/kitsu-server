class MediaReactionPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  alias_method :update?, :create?

  def destroy?
    record.try(:user) == user || is_admin?
  end

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
