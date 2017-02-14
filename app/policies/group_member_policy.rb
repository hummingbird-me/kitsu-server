class GroupMembersPolicy < ApplicationPolicy
  def edit?
    current_member.admin? || is_owner?
  end

  def create?
    is_owner?
  end

  def destroy?
    is_owner? || current_member.admin? || admin?
  end

  private

  def current_member
    group.member_for(user)
  end

  def group
    record.group
  end
end
