class CommentPolicy < ApplicationPolicy
  administrated_by :community_mod
  include GroupPermissionsHelpers

  def update?
    return false unless user
    return false if user.has_role?(:banned)
    return true if can_administrate?
    return true if group && has_group_permission?(:content)
    is_owner?
  end

  def create?
    return false unless user
    return false if user.unregistered?
    return false if user.blocked?(record.post.user)
    return false if user.has_role?(:banned)
    if group
      return false if banned_from_group?
      return false if group.closed? && !member?
    end

    # admins are allowed to create comments on locked posts
    if record.post.locked_by.present?
      is_owner? && is_admin?
    else
      is_owner?
    end
  end

  def destroy?
    return true if group && has_group_permission?(:content)
    is_owner? || can_administrate?
  end

  def editable_attributes(all)
    all - %i[content_formatted embed]
  end

  def group
    record.post.target_group
  end

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
