# Execute a PayPal Billing Agreement based on a provided token, and set up the User's
# ProSubscription to match it.
module Pro
  class SubscribeWithPayPal < Action
    include PayPal::SDK::REST

    parameter :user, required: true, load: User
    parameter :tier, required: true
    parameter :token, required: true

    validates :tier, inclusion: { in: %w[pro patron] }

    def call
      user.pro_subscription&.destroy!

      agreement = Agreement.new(token: token)
      agreement.execute!

      subscription = ProSubscription::PayPalSubscription.create!(
        user: user,
        tier: tier,
        billing_id: agreement.id
      )

      { subscription: subscription }
    end
  end
end
