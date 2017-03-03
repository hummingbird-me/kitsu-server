class GroupTicketPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    member?
  end

  def update?
    is_owner? || has_group_permission?(:tickets)
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
