require 'rails_helper'

RSpec.describe Billing::UpdateStripeSource do
  let(:user) { create(:user) }
  let(:stripe_mock) { StripeMock.create_test_helper }

  it 'changes the default payment method for the user' do
    token = stripe_mock.generate_card_token

    expect {
      Billing::UpdateStripeSource.call(user: user, token: token)
    }.to(change { user.stripe_customer.default_source })
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
