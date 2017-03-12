# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_ticket_messages
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  kind       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ticket_id  :integer          not null, indexed
#  user_id    :integer          not null
#
# Indexes
#
#  index_group_ticket_messages_on_ticket_id  (ticket_id)
#
# Foreign Keys
#
#  fk_rails_e77fcefb97  (ticket_id => group_tickets.id)
#
# rubocop:enable Metrics/LineLength

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
