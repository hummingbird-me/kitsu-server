require 'rails_helper'

RSpec.describe StripeRenewalService do
  let(:stripe_mock) { StripeMock.create_test_helper }

  before do
    stripe_mock.create_plan(id: 'pro-yearly')
  end

  it "updates the user's pro subscription for the period of the invoice" do
    user = create(:user, pro_expires_at: Time.now)
    user.stripe_customer.save(source: stripe_mock.generate_card_token)
    sub = ProSubscription::StripeSubscription.create!(user: user, tier: 'pro')
    invoice = Stripe::Invoice.create(
      subscription: sub.billing_id,
      period_start: Time.now,
      period_end: 30.days.from_now
    )
    expect {
      StripeRenewalService.new(invoice).call
    }.to(change { user.reload.pro_expires_at })
    expect(user.reload.pro_expires_at).to be > 29.days.from_now
  end
end
