require 'rails_helper'

RSpec.describe ProSubscription::StripeSubscription, type: :model do
  let(:stripe_mock) { StripeMock.create_test_helper }
  let!(:product) { stripe_mock.create_product(name: 'Pro Yearly') }

  before { stripe_mock.create_plan(id: 'pro-yearly', product: product.id) }

  describe '#billing_service' do
    it 'should return :stripe' do
      ProSubscription::StripeSubscription.new.billing_service
    end
  end

  context 'after destruction' do
    it 'should cancel the subscription on Stripe' do
      user = create(:user)
      user.stripe_customer.save(source: stripe_mock.generate_card_token)
      sub = ProSubscription::StripeSubscription.create!(user: user, tier: 'pro')
      expect(sub.subscription).to receive(:delete).once
      sub.destroy!
    end
  end

  context 'at creation' do
    it 'should create the subscription on Stripe' do
      user = create(:user)
      user.stripe_customer.save(source: stripe_mock.generate_card_token)
      sub = ProSubscription::StripeSubscription.create!(user: user, tier: 'pro')
      expect(sub.billing_id).not_to be_nil
    end
  end
end
