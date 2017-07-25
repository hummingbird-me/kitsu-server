class CommunityRecommendationRequestsPolicy < ApplicationPolicy
  def update?
    return true if is_admin?
    is_owner?
  end

  def create?
    record.user == user
  end

  def destroy?
    is_owner? || is_admin?
  end
end
