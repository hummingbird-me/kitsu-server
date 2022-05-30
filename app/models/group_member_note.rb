class GroupMemberNote < ApplicationRecord
  include ContentProcessable

  belongs_to :group_member, optional: false
  belongs_to :user, optional: false

  validates :content, presence: true

  processable :content, InlinePipeline

  scope :visible_for, ->(user) {
    members = GroupMember.with_permission(:members).for_user(user)
    joins(:group_member).where(group_members: {
      group_id: members.select(:group_id)
    })
  }
end
