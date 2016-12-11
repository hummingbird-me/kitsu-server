class PostPolicy < ApplicationPolicy
  def update?
    return true if is_admin?
    return false if record.created_at&.<(30.minutes.ago)
    is_owner?
  end

  def create?
    return false if user&.blocked?(record.target_user)
    is_owner?
  end

  def destroy?
    is_owner? || is_admin?
  end

  def editable_attributes(all)
    all - [:content_formatted]
  end

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
