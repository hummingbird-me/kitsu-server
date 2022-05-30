require 'rails_helper'

RSpec.describe ProSubscription, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:billing_id) }
end
