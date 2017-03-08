class GroupBanPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    has_group_permission?(:members)
  end
  alias_method :destroy?, :create?

  def update?
    false
  end

  def editable_attributes(all)
    all - %i[notes_formatted]
  end

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
