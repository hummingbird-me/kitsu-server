class CommunityRecommendationRequestPolicy < ApplicationPolicy
  administrated_by :community_mod

  def update?
    is_owner? || can_administrate?
  end

  def create?
    record.user == user
  end

  def destroy?
    is_owner? || can_administrate?
  end
end
