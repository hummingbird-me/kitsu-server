class GroupTicketMessage < ApplicationRecord
  belongs_to :ticket, class_name: 'GroupTicket', optional: false
  belongs_to :user, optional: false

  enum kind: { message: 0, mod_note: 1 }
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
