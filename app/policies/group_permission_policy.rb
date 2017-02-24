class GroupPermissionsPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def update?
    false
  end

  def create?
    has_group_permission? :leaders
  end
  alias_method :destroy?, :create?

  def group
    record.group
  end

  class Scope < Scope
    def resolve
      scope.where(group: Group.visible_for(user))
    end
  end
end
