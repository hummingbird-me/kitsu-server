class PostPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def update?
    return true if is_admin?
    return true if group && has_group_permission?(:content)
    return false if record.created_at&.<(30.minutes.ago)
    is_owner?
  end

  def create? # rubocop:disable Metrics/PerceivedComplexity
    return false unless user
    return false if user.unregistered?
    return false if user.blocked?(record.target_user)
    return false if user.has_role?(:banned)
    if group
      return false if banned_from_group?
      return false if group.restricted? && !has_group_permission?(:content)
      return false if group.closed? && !member?
    end
    is_owner?
  end

  def destroy?
    return true if group && has_group_permission?(:content)
    is_owner? || is_admin?
  end

  def editable_attributes(all)
    all - %i[content_formatted embed]
  end

  def group
    record.target_group
  end

  class Scope < Scope
    def resolve
      return scope if is_admin?
      visible = scope.visible_for(user).where.not(user_id: blocked_users)
      return visible.sfw unless see_nsfw?
      visible
    end
  end
end
