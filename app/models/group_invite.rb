class GroupInvite < ApplicationRecord
  include WithActivity

  belongs_to :group, required: true
  belongs_to :user, required: true
  belongs_to :sender, class_name: 'User', required: true

  # Limit to one pending invite per user per group
  validates :user, uniqueness: {
    scope: :group_id,
    conditions: -> { pending }
  }
  validate :not_inviting_self
  validate :not_banned
  validate :not_already_member
  validate :invitee_following_sender

  scope :visible_for, ->(user) {
    # user == user || has members or owner priv
    members = GroupMember.with_permission(:members).for_user(user)
    groups = members.select(:group_id)
    where(group_id: groups).or(where(user: user))
  }
  scope :pending, -> {
    where(accepted_at: nil, revoked_at: nil, declined_at: nil)
  }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :declined, -> { where.not(declined_at: nil) }
  scope :revoked, -> { where.not(revoked_at: nil) }
  scope :by_status, ->(status) {
    return none unless status.in? %w[accepted declined revoked pending]
    send(status)
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
    update(revoked_at: Time.now)
    complete_stream_activity.destroy
  end

  def stream_activity
    user.notifications.activities.new(
      verb: 'invited',
      actor: sender
    )
  end

  def not_inviting_self
    errors.add(:user, 'cannot be same as sender') if user == sender
  end

  def not_banned
    errors.add(:user, 'is banned') if GroupBan.where(group: group, user: user).exists?
  end

  def not_already_member
    errors.add(:user, 'is already a member') if GroupMember.where(group: group, user: user).exists?
  end

  def invitee_following_sender
    unless Follow.where(follower: user, followed: sender).exists?
      errors.add(:user, 'does not follow you')
    end
  end
end
