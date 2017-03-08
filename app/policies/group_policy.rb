class GroupPolicy < ApplicationPolicy
  include GroupPermissionsHelpers

  def create?
    !!user
  end

  def update?
    has_group_permission? :community
  end

  def destroy?
    has_group_permission? :owner
  end

  def editable_attributes(all)
    return all if is_admin?

    # Don't allow a closed group to change privacy setting
    going_public = model.closed? ? %i[privacy] : []
    all - %i[members_count leaders_count neighbors_count rules_formatted
             featured] - going_public
  end

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
