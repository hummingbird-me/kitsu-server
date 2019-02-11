module Billing
  class StripeCharge < Action
    # Stripe uses integer cents for the transaction amount
    parameter :amount, required: true, cast: ->(dec) { (dec * 100).to_i }
    parameter :token, required: true
    parameter :description, required: false
    parameter :metadata, required: false

    def call
      Stripe::Charge.create(
        amount: amount,
        currency: 'usd',
        description: description,
        source: token,
        metadata: metadata
      )
    end
  end
end
