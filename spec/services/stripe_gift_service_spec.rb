require 'rails_helper'

RSpec.describe StripeGiftService do
  let(:stripe_mock) { StripeMock.create_test_helper }

  context 'with a valid card' do
    it 'should charge the Stripe token the price of a year of PRO ($36)' do
      token = stripe_mock.generate_card_token
      from = create(:user)
      to = build(:user)
      expect(Stripe::Charge).to receive(:create).once.with(
        match_json_expression({
          amount: 36_00,
          currency: 'usd',
          source: token
        }.ignore_extra_keys!)
      )
      StripeGiftService.new(token: token, from: from, to: to).call
    end
  end
end
