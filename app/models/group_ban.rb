class GroupBan < ApplicationRecord
  include ContentProcessable

  belongs_to :group, optional: false
  belongs_to :user, optional: false
  belongs_to :moderator, class_name: 'User', optional: false

  processable :notes, InlinePipeline

  validates :user, uniqueness: { scope: %i[group_id] }

  scope :visible_for, ->(user) {
    members = GroupMember.with_permission(:members).for_user(user)
    where(group_id: members.select(:group_id))
  }

  after_create do
    # Kick the user from the group
    GroupMember.where(user: user, group: group).first&.destroy!
    GroupInvite.where(user: user, group: group).update_all(revoked_at: Time.now)
  end
end
