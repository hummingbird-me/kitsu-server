class PostPolicy < ApplicationPolicy
  def update?
    return true if is_admin?
    return false if record.created_at&.<(30.minutes.ago)
    record.user_id_was == user.id
  end

  def create?
    return false if user&.blocked?(record.target_user)
    record.user == user
  end

  def destroy?
    record.user == user || is_admin?
  end

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
