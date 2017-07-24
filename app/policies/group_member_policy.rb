class GroupMemberPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def update?
    required_permission = record.pleb? ? :members : :leaders
    is_owner? || has_group_permission?(required_permission)
  end
  alias_method :update?, :destroy?

  def create?
    return false unless is_owner?
    return false if banned_from_group?
    group.open? || group.restricted?
  end

  def destroy?
    required_permission = record.pleb? ? :members : :leaders
    is_owner? || has_group_permission?(required_permission)
  end

  def visible_attributes(all)
    is_owner? ? all : all - %i[hidden]
  end

  def editable_attributes(all)
    attrs = all - %i[hidden] unless is_owner?
    return attrs - %i[rank] unless has_group_permission?(:leaders)
    attrs
  end

  class Scope < Scope
    def resolve
      filted_scope = see_nsfw? ? scope : scope.sfw
      filted_scope.blocking(blocked_users).visible_for(user)
    end
  end
end
