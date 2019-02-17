module Billing
  class BraintreeCharge < Action
    # Braintree transmits the amount as a string
    parameter :amount, required: true, cast: ->(amount) { format('%.2f', amount) }
    parameter :nonce, required: true
    parameter :description, required: false
    parameter :custom_fields, required: false

    def call
      $braintree.transaction.sale!(
        amount: amount,
        payment_method_nonce: nonce,
        custom_fields: custom_fields,
        options: {
          submit_for_settlement: true,
          paypal: {
            description: description
          }
        }
      )
    end
  end
end
