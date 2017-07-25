module GroupPermissionsHelpers
  extend ActiveSupport::Concern

  private

  # The Group of the current record.  Returns nil if the record isn't a record
  def group
    return if record.respond_to?(:where)
    record.group
  end

  # The GroupMember object for the current user
  #
  # @return [GroupMember, nil] the membership of the current user in the group
  def member
    group&.member_for(user)
  end

  # Is the current user a member of the group?
  #
  # @return [Boolean] whether the current user is a member or not
  def member?
    member.present?
  end

  # Is the current user a leader of any type?
  #
  # @return [Boolean] whether the current user is a leader
  def leader?
    member.leader?
  end

  # Is the current user banned from the group?
  #
  # @return [Boolean] whether the current user is banned from the group
  def banned_from_group?
    GroupBan.where(user: user, group: group).exists?
  end

  # Does the current member have the permission requested?
  #
  # @param [Symbol] permission what permission we are inquiring about
  # @return [Boolean] whether the current member has that permission
  def has_group_permission?(permission)
    return false unless group
    return true if is_admin?
    member? && member.has_permission?(permission)
  end
end
