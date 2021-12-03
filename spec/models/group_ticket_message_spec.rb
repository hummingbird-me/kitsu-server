require 'rails_helper'

RSpec.describe GroupTicketMessage, type: :model do
  it { should belong_to(:user).required }
  it { should belong_to(:ticket).class_name('GroupTicket').required }
end
