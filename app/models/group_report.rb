class GroupReport < ApplicationRecord
  include WithActivity

  belongs_to :group, optional: false
  belongs_to :naughty, -> { with_deleted }, polymorphic: true, optional: false
  belongs_to :user, optional: false
  belongs_to :moderator, class_name: 'User', optional: true

  enum reason: Report.reasons
  enum status: { reported: 0, resolved: 1, declined: 2, escalated: 3 }

  scope :visible_for, ->(user) {
    # user == user || has content priv
    members = GroupMember.with_permission(:content).for_user(user)
    groups = members.select(:group_id)
    where(group_id: groups).or(where(user: user))
  }
  scope :in_group, ->(group) { where(group: group) }

  validates :explanation, presence: true, if: :other?
  validates :reason, :status, presence: true

  def stream_activity
    ReportsFeed.new(group_id).activities.new(naughty: naughty)
  end

  def escalate!
    Report.create!(
      naughty: naughty,
      user: user,
      reason: reason,
      explanation: explanation
    )
  end

  before_save do
    escalate! if status_changed? && escalated?
  end
end
