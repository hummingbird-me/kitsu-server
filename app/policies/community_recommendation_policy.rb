class CommunityRecommendationsPolicy < ApplicationPolicy
  def update?
    return true if is_admin?
    return false if record.created_at&.<(30.minutes.ago)
    is_owner?
  end

  def create?
    record.user == user
  end

  def destroy?
    is_owner? || is_admin?
  end
end
