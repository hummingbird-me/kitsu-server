# frozen_string_literal: true

class GroupPolicy < ApplicationPolicy
  administrated_by :community_mod
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
    return all if can_administrate?
    all - %i[members_count leaders_count neighbors_count rules_formatted featured name]
  end

  def creatable_attributes(all)
    return all if can_administrate?
    all - %i[members_count leaders_count neighbors_count rules_formatted featured]
  end

  def group
    record
  end

  class Scope < Scope
    def resolve
      return scope if can_administrate?
      return scope.visible_for(user) if see_nsfw?
      scope.sfw.visible_for(user)
    end
  end

  class AlgoliaScope < AlgoliaScope
    def resolve
      group_ids = GroupMember.joins(:group).merge(Group.closed).for_user(user).pluck(:group_id)
      groups = group_ids.map { |id| "id = #{id}" }
      private_groups = [*groups].compact.join(' OR ')
      public_groups = 'privacy:open OR privacy:restricted'
      visible_groups = groups.empty? ? public_groups : "(#{private_groups}) OR (#{public_groups})"
      see_nsfw? ? visible_groups : "(#{visible_groups}) AND NOT nsfw:true"
    end
  end

  class TypesenseScope < TypesenseScope
    def resolve
      group_ids = GroupMember.joins(:group).merge(Group.closed).for_user(user).pluck(:group_id)
      search = search.filter("(id:=[#{group_ids.compact.join(',')}] || privacy:=[open,restricted])")
      see_nsfw? ? search : search.filter('is_nsfw:=false')
    end
  end
end
