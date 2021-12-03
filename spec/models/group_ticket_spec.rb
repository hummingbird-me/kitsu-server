require 'rails_helper'

RSpec.describe GroupTicket, type: :model do
  it { should belong_to(:group).required }
  it { should belong_to(:user).required }
  it { should belong_to(:assignee).class_name('User').optional }
  it { should define_enum_for(:status) }
  it do
    should have_many(:messages).class_name('GroupTicketMessage')
      .with_foreign_key('ticket_id')
  end
end
