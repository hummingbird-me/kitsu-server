class GroupMemberPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def update?
    has_group_permission?(:members)
  end

  def create?
    return false unless is_owner?
    return false if banned_from_group?
    group.open? || group.restricted?
  end

  def destroy?
    is_owner? || has_group_permission?(:members)
  end

  class Scope < Scope
    def resolve
      scope.blocking(blocked_users)
    end
  end
end
