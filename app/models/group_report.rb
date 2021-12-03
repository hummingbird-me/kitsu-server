class GroupReport < ApplicationRecord
  include WithActivity

  belongs_to :group, required: true
  belongs_to :naughty, -> { with_deleted }, polymorphic: true, required: true
  belongs_to :user, required: true
  belongs_to :moderator, class_name: 'User', optional: true

  enum reason: Report.reasons
  enum status: %i[reported resolved declined escalated]

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
