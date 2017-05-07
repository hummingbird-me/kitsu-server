# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_tickets
#
#  id               :integer          not null, primary key
#  status           :integer          default(0), not null, indexed
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  assignee_id      :integer          indexed
#  first_message_id :integer
#  group_id         :integer          not null, indexed
#  user_id          :integer          not null, indexed
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
#  fk_rails_f2a96e30ec  (first_message_id => group_ticket_messages.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe GroupTicket, type: :model do
  it { should belong_to(:group) }
  it { should validate_presence_of(:group) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:assignee).class_name('User') }
  it { should define_enum_for(:status) }
  it do
    should have_many(:messages).class_name('GroupTicketMessage')
      .with_foreign_key('ticket_id')
  end
end
