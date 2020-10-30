class CommunityRecommendationFollowPolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    record.user == user
  end

  def destroy?
    is_owner?
  end
end
