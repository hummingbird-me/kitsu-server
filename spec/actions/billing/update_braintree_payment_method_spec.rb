require 'rails_helper'

RSpec.describe Billing::UpdateBraintreePaymentMethod do
  let(:user) { build(:user) }

  describe 'with a valid subscription paypal nonce' do
    it 'should update the user default payment method' do
      payment_method = Billing::UpdateBraintreePaymentMethod.call(
        user: user,
        nonce: 'fake-paypal-billing-agreement-nonce'
      )

      expect(payment_method).to be_a(Braintree::PayPalAccount)
      expect(payment_method).to be_default
    end
  end

  describe 'with an invalid payment nonce' do
    it 'should fail loudly' do
      expect {
        Billing::UpdateBraintreePaymentMethod.call(
          user: user,
          nonce: 'fake-consumed-nonce'
        )
      }.to raise_error(Braintree::BraintreeError)
    end
  end
end
