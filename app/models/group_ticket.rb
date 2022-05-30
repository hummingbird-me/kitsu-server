class GroupTicket < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :group, optional: false
  belongs_to :assignee, class_name: 'User', optional: true
  belongs_to :first_message, class_name: 'GroupTicketMessage', optional: true
  has_many :messages, class_name: 'GroupTicketMessage', foreign_key: 'ticket_id',
    dependent: :destroy

  enum status: { created: 0, assigned: 1, resolved: 2 }
  update_index('group_tickets#group_ticket') { self }

  scope :visible_for, ->(user) {
    members = GroupMember.with_permission(:tickets).for_user(user)
    groups = members.select(:group_id)
    where(group_id: groups).or(where(user: user))
  }
  scope :in_group, ->(group) { where(group_id: group) }
end
