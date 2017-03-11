# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_bans
#
#  id              :integer          not null, primary key
#  notes           :text
#  notes_formatted :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  group_id        :integer          not null, indexed
#  moderator_id    :integer          not null
#  user_id         :integer          not null, indexed
#
# Indexes
#
#  index_group_bans_on_group_id  (group_id)
#  index_group_bans_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_7dd1d13ab5  (group_id => groups.id)
#  fk_rails_816d72c5df  (user_id => users.id)
#  fk_rails_bf82b17bd6  (moderator_id => users.id)
#
# rubocop:enable Metrics/LineLength

class GroupBan < ApplicationRecord
  include ContentProcessable

  belongs_to :group, required: true
  belongs_to :user, required: true
  belongs_to :moderator, class_name: 'User', required: true

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
