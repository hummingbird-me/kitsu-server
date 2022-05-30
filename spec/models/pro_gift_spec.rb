require 'rails_helper'

RSpec.describe ProGift, type: :model do
  it { is_expected.to belong_to(:from).class_name('User').required }
  it { is_expected.to belong_to(:to).class_name('User').required }
  it { is_expected.to validate_length_of(:message).is_at_most(500) }
end
