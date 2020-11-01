class AMAPolicy < ApplicationPolicy
  administrated_by :community_mod

  def update?
    record.author == user || can_administrate?
  end

  def destroy?
    record.author == user || can_administrate?
  end

  def create?
    can_administrate?
  end
end
