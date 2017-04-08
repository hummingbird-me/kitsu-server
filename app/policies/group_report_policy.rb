class GroupReportPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    member.present?
  end

  def update?
    is_owner? || has_group_permission?(:content)
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
