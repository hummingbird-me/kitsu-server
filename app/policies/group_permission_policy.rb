class GroupPermissionPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def update?
    false
  end

  def create?
    has_group_permission? :leaders
  end
  alias_method :destroy?, :create?

  def group
    record.group_member.group
  end
end
