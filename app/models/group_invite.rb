# == Schema Information
#
# Table name: group_invites
#
#  id          :integer          not null, primary key
#  accepted_at :datetime
#  declined_at :datetime
#  revoked_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  group_id    :integer          not null, indexed
#  sender_id   :integer          not null, indexed
#  user_id     :integer          not null, indexed
#
# Indexes
#
#  index_group_invites_on_group_id   (group_id)
#  index_group_invites_on_sender_id  (sender_id)
#  index_group_invites_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_62774fb6d2  (sender_id => users.id)
#  fk_rails_7255dc4343  (group_id => groups.id)
#  fk_rails_d969f0761c  (user_id => users.id)
#

class GroupInvite < ApplicationRecord
  include WithActivity

  belongs_to :group, required: true
  belongs_to :user, required: true
  belongs_to :sender, class_name: 'User', required: true

  scope :visible_for, ->(user) {
    # user == user || has members or owner priv
    members = GroupMember.with_permission(:members).for_user(user)
    groups = members.select(:group_id)
    where(group_id: groups).or(where(user: user))
  }

  def accepted?
    accepted_at?
  end

  def revoked?
    revoked_at?
  end

  def declined?
    declined_at?
  end

  def unacceptable?
    accepted? || revoked? || declined?
  end

  def acceptable?
    !unacceptable?
  end

  def accept!
    update(accepted_at: Time.now)
    GroupMember.create(group: group, user: user)
  end

  def decline!
    update(declined_at: Time.now)
  end

  def revoke!
    update(declined_at: Time.now)
  end

  def stream_activity
    user.notifications.activities.new(
      verb: 'invited',
      actor: sender
    )
  end
end
