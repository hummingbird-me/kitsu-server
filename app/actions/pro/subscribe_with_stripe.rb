module Pro
  class SubscribeWithStripe < Action
    parameter :user, required: true, load: User
    parameter :tier, required: true
    parameter :token, required: true

    # Only allow subscribing to pro or patron tiers
    validates :tier, inclusion: { in: %w[pro patron] }

    def call
      user.pro_subscription&.destroy!

      Billing::UpdateStripeSource.call(user: user, token: token)
      subscription = ProSubscription::StripeSubscription.create!(user: user, tier: tier)

      { subscription: subscription }
    end
  end
end
