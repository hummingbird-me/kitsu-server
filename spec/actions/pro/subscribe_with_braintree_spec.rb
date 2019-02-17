require 'rails_helper'

RSpec.describe Pro::SubscribeWithBraintree do
  let(:user) { create(:user) }

  it 'should change the default payment method for the user' do
    expect {
      Pro::SubscribeWithBraintree.call(
        user: user,
        tier: 'pro',
        nonce: 'fake-paypal-billing-agreement-nonce'
      )
    }.to(change { user.braintree_customer.payment_methods.find(&:default?) })
  end

  it 'should create a BraintreeSubscription object' do
    expect {
      Pro::SubscribeWithBraintree.call(
        user: user,
        tier: 'pro',
        nonce: 'fake-paypal-billing-agreement-nonce'
      )
    }.to(change { user.pro_subscription })
  end

  it 'should return the subscription instance as `subscription`' do
    result = Pro::SubscribeWithBraintree.call(
      user: user,
      tier: 'patron',
      nonce: 'fake-paypal-billing-agreement-nonce'
    )
    expect(result.subscription).to be_a(ProSubscription::BraintreeSubscription)
  end

  context 'with an invalid subscription tier' do
    it 'should raise a ValidationError' do
      expect {
        Pro::SubscribeWithBraintree.call(
          user: user,
          tier: 'godly',
          nonce: 'fake-paypal-billing-agreement-nonce'
        )
      }.to raise_error(Action::ValidationError)
    end
  end

  context 'attempting to subscribe with an Aozora pro tier' do
    it 'should raise a ValidationError' do
      expect {
        Pro::SubscribeWithBraintree.call(
          user: user,
          tier: 'ao_pro',
          nonce: 'fake-paypal-billing-agreement-nonce'
        )
      }.to raise_error(Action::ValidationError)
    end
  end

  context 'with an invalid stripe token' do
    it 'should raise a Braintree::BraintreeError' do
      expect {
        Pro::SubscribeWithBraintree.call(
          user: user,
          tier: 'pro',
          nonce: 'fake-consumed-nonce'
        )
      }.to raise_error(Braintree::BraintreeError)
    end
  end
end
