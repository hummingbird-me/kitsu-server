require 'rails_helper'

RSpec.describe ProSubscription::PayPalSubscription, type: :model do
  describe '#billing_service' do
    it 'should return :paypal' do
      expect(ProSubscription::PayPalSubscription.new.billing_service).to eq(:paypal)
    end
  end

  context 'after destruction' do
    it 'should cancel the agreement on PayPal' do
      user = create(:user)
      sub = ProSubscription::PayPalSubscription.create!(user: user, tier: 'pro', billing_id: 'POOP')
      agreement = instance_double(PayPal::SDK::REST::Agreement)
      allow(sub).to receive(:agreement).and_return(agreement)
      expect(sub.agreement).to receive(:cancel!).once
      sub.destroy!
    end
  end
end
