class PostPolicy < ApplicationPolicy
  def update?
    return true if is_admin?
    return false if record.created_at&.<(30.minutes.ago)
    record.user == user
  end

  def create?
    record.user == user
  end

  def destroy?
    record.user == user || is_admin?
  end
end
