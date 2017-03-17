class MediaFollowPolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    return false if record == MediaFollow
    record.user == user
  end

  def destroy?
    record.try(:user) == user || is_admin?
  end
end
