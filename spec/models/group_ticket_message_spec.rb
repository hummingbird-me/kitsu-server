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

require 'rails_helper'

RSpec.describe GroupTicketMessage, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:ticket).class_name('GroupTicket') }
  it { should validate_presence_of(:ticket) }
end
