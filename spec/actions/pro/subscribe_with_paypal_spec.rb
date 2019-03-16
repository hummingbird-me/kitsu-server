require 'rails_helper'

RSpec.describe Pro::SubscribeWithPayPal do
  it 'should execute an agreement based on a token' do
    agreement = instance_double(PayPal::SDK::REST::Agreement)
    expect(agreement).to receive(:execute!)
    allow(agreement).to receive(:id).and_return('IH8PAYPAL')
    allow(PayPal::SDK::REST::Agreement).to receive(:new).and_return(agreement)

    result = Pro::SubscribeWithPayPal.call(user: build(:user), tier: 'pro', token: 'POOP')
    expect(result.subscription.billing_id).to eq('IH8PAYPAL')
  end
end
