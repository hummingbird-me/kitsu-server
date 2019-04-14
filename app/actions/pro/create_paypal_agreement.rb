# Create a PayPal Billing Agreement to be authorized by a user and return the token which can be
# used to authorize it on the client side.
module Pro
  class CreatePaypalAgreement < Action
    include PayPal::SDK::REST

    parameter :user, required: true, load: User
    parameter :tier, required: true

    validates :tier, inclusion: { in: %w[pro patron] }

    def call
      agreement = Agreement.new(
        start_date: 30.seconds.from_now.iso8601,
        payer: { payment_method: 'paypal' },
        name: "Kitsu #{tier.upcase}",
        description: "Yearly Kitsu #{tier.upcase} Subscription",
        plan: paypal_plan
      )

      agreement.create!

      { token: agreement.token }
    end

    private

    def paypal_plan_id
      ENV["PAYPAL_#{tier.upcase}_PLAN"]
    end

    def paypal_plan
      Plan.new(id: paypal_plan_id)
    end
  end
end
