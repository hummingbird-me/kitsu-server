class RepostPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create?
    is_owner?
  end

  def update?
    false
  end

  def destroy?
    is_owner? || can_administrate?
  end
end
