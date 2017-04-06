class GroupMemberNotePolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def update?
    is_owner? && has_group_permission?(:members)
  end
  alias_method :destroy?, :create?
  alias_method :create?, :update?

  def editable_attributes(all)
    all - %i[content_formatted]
  end

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
