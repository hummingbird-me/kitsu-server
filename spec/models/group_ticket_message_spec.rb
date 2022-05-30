require 'rails_helper'

RSpec.describe GroupTicketMessage, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:ticket).class_name('GroupTicket').required }
end
