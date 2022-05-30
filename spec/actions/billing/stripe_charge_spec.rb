require 'rails_helper'

RSpec.describe Billing::StripeCharge do
  let(:stripe_mock) { StripeMock.create_test_helper }

  it 'casts the amount from BigDecimal to integer cents' do
    action = Billing::StripeCharge.new(amount: BigDecimal('4.20'))
    expect(action.amount).to equal(420)
  end

  describe '#call' do
    it 'charges the Stripe token' do
      token = stripe_mock.generate_card_token

      expect(Stripe::Charge).to receive(:create).once.with(
        match_json_expression({
          amount: 420,
          currency: 'usd',
          source: token
        }.ignore_extra_keys!)
      )
      Billing::StripeCharge.call(amount: BigDecimal('4.20'), token: token)
    end
  end
end
