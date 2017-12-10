class CommunityRecommendationRequestPolicy < ApplicationPolicy
  def update?
    is_owner? || is_admin?
  end

  def create?
    record.user == user
  end

  def destroy?
    is_owner? || is_admin?
  end
end
