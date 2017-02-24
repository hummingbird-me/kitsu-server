class GroupInvitePolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    has_group_permission? :members
  end

  def update?
    has_group_permission? :members
  end

  def destroy?
    has_group_permission? :members
  end

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
