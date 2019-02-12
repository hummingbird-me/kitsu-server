module Billing
  class UpdateStripeSource < Action
    parameter :user, required: true, load: User
    parameter :token, required: true

    def call
      customer = user.stripe_customer
      customer.source = token
      customer.save
    end
  end
end
