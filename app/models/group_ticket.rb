# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_tickets
#
#  id          :integer          not null, primary key
#  status      :integer          default(0), not null, indexed
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  assignee_id :integer          indexed
#  group_id    :integer          not null, indexed
#  user_id     :integer          not null, indexed
#
# Indexes
#
#  index_group_tickets_on_assignee_id  (assignee_id)
#  index_group_tickets_on_group_id     (group_id)
#  index_group_tickets_on_status       (status)
#  index_group_tickets_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_491e1dcdd8  (assignee_id => users.id)
#  fk_rails_58b133f20c  (group_id => groups.id)
#  fk_rails_d841b96836  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class GroupTicket < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :group, required: true
  belongs_to :assignee, class_name: 'User'
  has_many :messages, class_name: 'GroupTicketMessage', foreign_key: 'ticket_id'

  enum status: %i[created assigned resolved]

  scope :visible_for, ->(user) {
    members = GroupMember.with_permission(:tickets).for_user(user)
    groups = members.select(:group_id)
    where(group_id: groups).or(where(user: user))
  }
  scope :in_group, ->(group) { where(group: group) }
end
