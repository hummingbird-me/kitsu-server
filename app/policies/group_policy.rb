class GroupPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    !!user
  end

  def update?
    has_group_permission? :community
  end

  def destroy?
    has_group_permission? :owner
  end

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
