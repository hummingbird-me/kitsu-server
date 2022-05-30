require 'rails_helper'

RSpec.describe GroupTicket, type: :model do
  it { is_expected.to belong_to(:group).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:assignee).class_name('User').optional }
  it { is_expected.to define_enum_for(:status) }

  it do
    is_expected.to have_many(:messages).class_name('GroupTicketMessage')
                                       .with_foreign_key('ticket_id')
  end
end
