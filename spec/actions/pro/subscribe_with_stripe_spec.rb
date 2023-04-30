require 'rails_helper'

RSpec.describe Pro::SubscribeWithStripe do
  let(:user) { create(:user) }
  let(:stripe_mock) { StripeMock.create_test_helper }
  let(:token) { stripe_mock.generate_card_token }
  let!(:product) { stripe_mock.create_product(name: 'Pro Yearly') }

  before { stripe_mock.create_plan(id: 'pro-yearly', product: product.id) }

  it 'changes the default payment method for the user' do
    expect {
      described_class.call(user: user, tier: 'pro', token: token)
    }.to(change { user.stripe_customer.default_source })
  end

  it 'creates a StripeSubscription object' do
    expect {
      described_class.call(user: user, tier: 'pro', token: token)
    }.to change(user, :pro_subscription)
  end

  it 'returns the subscription instance as `subscription`' do
    result = described_class.call(user: user, tier: 'pro', token: token)
    expect(result.subscription).to be_a(ProSubscription::StripeSubscription)
  end

  context 'with an invalid subscription tier' do
    it 'raises a ValidationError' do
      expect {
        described_class.call(user: user, tier: 'godly', token: token)
      }.to raise_error(Action::ValidationError)
    end
  end

  context 'when attempting to subscribe with an Aozora pro tier' do
    it 'raises a ValidationError' do
      expect {
        described_class.call(user: user, tier: 'ao_pro', token: token)
      }.to raise_error(Action::ValidationError)
    end
  end

  context 'with an invalid stripe token' do
    it 'raises a Stripe::CardError' do
      StripeMock.prepare_card_error(:invalid_number, :update_customer)
      expect {
        Billing::UpdateStripeSource.call(user: user, token: stripe_mock.generate_card_token)
      }.to raise_error(Stripe::CardError)
    end
  end
end
