# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_member_notes
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  group_member_id   :integer          not null
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_b689eab49d  (group_member_id => group_members.id)
#  fk_rails_ea0e9e51b1  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class GroupMemberNote < ApplicationRecord
  include ContentProcessable

  belongs_to :group_member, required: true
  belongs_to :user, required: true

  validates :content, presence: true

  processable :content, InlinePipeline

  scope :visible_for, ->(user) {
    members = GroupMember.with_permission(:members).for_user(user)
    joins(:group_member).where(group_members: {
      group_id: members.select(:group_id)
    })
  }
end
