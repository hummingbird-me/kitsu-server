require 'rails_helper'

RSpec.describe ProGift, type: :model do
  it { should belong_to(:from).class_name('User').required }
  it { should belong_to(:to).class_name('User').required }
  it { should validate_length_of(:message).is_at_most(500) }
end
