class GroupPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    user ? true : false
  end

  def update?
    has_group_permission? :community
  end

  def destroy?
    has_group_permission? :owner
  end

  def editable_attributes(all)
    return all if is_admin?
    attrs = all
    attrs -= %i[members_count leaders_count neighbors_count rules_formatted featured name]
    attrs -= %i[pinned_post_id] unless record.owners.include? user
    attrs
  end

  def creatable_attributes(all)
    return all if is_admin?
    attrs = all
    attrs -= %i[members_count leaders_count neighbors_count rules_formatted featured name]
    attrs -= %i[pinned_post_id] unless record.owners.include? user
    attrs
  end

  def group
    record
  end

  class Scope < Scope
    def resolve
      return scope.visible_for(user) if see_nsfw?
      scope.sfw.visible_for(user)
    end
  end
end
