class AMAPolicy < ApplicationPolicy
  administrated_by :community_mod

  def update?
    record.author == user || is_admin?
  end

  def destroy?
    record.author == user || is_admin?
  end

  def create?
    can_administrate?
  end
end
