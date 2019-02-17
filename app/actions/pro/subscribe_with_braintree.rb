module Pro
  class SubscribeWithBraintree < Action
    parameter :user, required: true, load: User
    parameter :tier, required: true
    parameter :nonce, required: true

    # Only allow subscribing to pro or patron tiers
    validates :tier, inclusion: { in: %w[pro patron] }

    def call
      Billing::UpdateBraintreePaymentMethod.call(user: user, nonce: nonce)
      subscription = ProSubscription::BraintreeSubscription.create!(user: user, tier: tier)

      { subscription: subscription }
    end
  end
end
