class GroupNeighborPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    has_group_permission? :community
  end
  alias_method :destroy?, :create?

  def update?
    false
  end

  def group
    record.source
  end
end
