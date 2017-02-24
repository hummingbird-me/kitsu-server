module GroupPermissionsHelpers
  extend ActiveSupport::Concern

  private

  # The Group of the current record
  delegate :group, to: :record

  # The GroupMember object for the current user
  #
  # @return [GroupMember, nil] the membership of the current user in the group
  def member
    group.member_for(current_user)
  end

  # Is the current user a member of the group?
  #
  # @return [Boolean] whether the current user is a member or not
  def member?
    member.present?
  end

  # Does the current member have the permission requested?
  #
  # @param [Symbol] permission what permission we are inquiring about
  # @return [Boolean] whether the current member has that permission
  def has_group_permission?(permission)
    member? && member.has_permission?(permission)
  end
end
