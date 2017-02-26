class GroupMemberPolicy < ApplicationPolicy
  def edit?
    current_member.admin? || is_owner?
  end

  def create?
    return false unless is_owner?
    group.open? || group.restricted?
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
