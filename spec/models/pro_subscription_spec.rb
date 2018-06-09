require 'rails_helper'

RSpec.describe ProSubscription, type: :model do
  it { should belong_to(:user) }
  it { should define_enum_for(:billing_service) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:billing_service) }
  it { should validate_presence_of(:customer_id) }
end
