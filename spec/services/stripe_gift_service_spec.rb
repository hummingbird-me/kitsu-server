require 'rails_helper'

RSpec.describe StripeGiftService do
  let(:stripe_mock) { StripeMock.create_test_helper }

  context 'with a valid card and a year length' do
    it 'should charge the Stripe token the price of a year of PRO ($29.99)' do
      token = stripe_mock.generate_card_token
      from = create(:user)
      to = build(:user)

      expect(Stripe::Charge).to receive(:create).once.with(
        match_json_expression({
          amount: 29_99,
          currency: 'usd',
          source: token
        }.ignore_extra_keys!)
      )
      StripeGiftService.new(token: token, from: from, to: to, length: :year).call
    end
  end

  context 'with a valid card and a month length' do
    it 'should charge the Stripe token the price of a month of PRO ($2.99)' do
      token = stripe_mock.generate_card_token
      from = create(:user)
      to = build(:user)

      expect(Stripe::Charge).to receive(:create).once.with(
        match_json_expression({
          amount: 2_99,
          currency: 'usd',
          source: token
        }.ignore_extra_keys!)
      )
      StripeGiftService.new(token: token, from: from, to: to, length: :month).call
    end
  end
end
