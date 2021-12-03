class GroupTicketMessage < ApplicationRecord
  belongs_to :ticket, class_name: 'GroupTicket', required: true
  belongs_to :user, required: true

  enum kind: %i[message mod_note]
  update_index('group_tickets#group_ticket') { ticket }

  scope :visible_for, ->(user) {
    members = GroupMember.with_permission(:tickets).for_user(user)
    groups = members.select(:group_id)
    joins(:ticket).merge(GroupTicket.in_group(groups)).or(
      GroupTicketMessage.message.joins(:ticket)
        .merge(GroupTicket.visible_for(user))
    )
  }

  after_create do
    ticket.update(first_message: self) unless ticket.first_message
  end
end
