# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_permissions
#
#  id              :integer          not null, primary key
#  permission      :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  group_member_id :integer          not null, indexed
#
# Indexes
#
#  index_group_permissions_on_group_member_id  (group_member_id)
#
# Foreign Keys
#
#  fk_rails_f60693a634  (group_member_id => group_members.id)
#
# rubocop:enable Metrics/LineLength

class GroupPermission < ApplicationRecord
  belongs_to :group_member, required: true

  # Specifies which permission is provided by this.  Permissions are as follows:
  #
  #  * owner - has all permissions, can give owner status to another leader or
  #            delete the group
  #  * tickets - can view, respond to, and manage help desk requests
  #  * members - can invite and ban members
  #  * leaders - can edit permissions for other leaders (except owner)
  #  * community - can edit community settings (bio, cover, avatar, rules, etc.)
  #  * content - can manage posts and comments in the community
  #
  # @!attribute [rw] permission
  # @return [owner tickets members leaders community content]
  enum permission: %i[owner tickets members leaders community content]

  scope :for_permission, ->(perm) { send(perm).or(owner) }

  after_create { group_member.regenerate_rank! }
  after_destroy { group_member.regenerate_rank! }

  validate(on: :destroy) do
    if owner? && group_member.group.owners.count == 1
      errors.add(:group, 'must always have at least one owner')
    end
  end
end
