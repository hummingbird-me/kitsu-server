class GroupBanPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    has_group_permission?(:members)
  end
  alias_method :destroy?, :create?

  def update?
    false
  end

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
