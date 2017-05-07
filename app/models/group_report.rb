# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_reports
#
#  id           :integer          not null, primary key
#  explanation  :text
#  naughty_type :string           not null, indexed => [naughty_id]
#  reason       :integer          not null
#  status       :integer          default(0), not null, indexed
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :integer          not null, indexed
#  moderator_id :integer
#  naughty_id   :integer          not null, indexed => [naughty_type]
#  user_id      :integer          not null, indexed
#
# Indexes
#
#  index_group_reports_on_group_id                     (group_id)
#  index_group_reports_on_naughty_type_and_naughty_id  (naughty_type,naughty_id)
#  index_group_reports_on_status                       (status)
#  index_group_reports_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_13d07d040e  (group_id => groups.id)
#  fk_rails_32fa0c6a2d  (moderator_id => users.id)
#  fk_rails_8abfbfa356  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class GroupReport < ApplicationRecord
  include WithActivity

  belongs_to :group, required: true
  belongs_to :naughty, -> { with_deleted }, polymorphic: true, required: true
  belongs_to :user, required: true
  belongs_to :moderator, class_name: 'User', required: false

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
