require 'rails_helper'

RSpec.describe ProSubscription, type: :model do
  it { should belong_to(:user).required }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:billing_id) }
end
