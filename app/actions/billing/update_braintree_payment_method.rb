module Billing
  class UpdateBraintreePaymentMethod < Action
    parameter :user, required: true, load: User
    parameter :nonce, required: true

    def call
      $braintree.payment_method.create!(
        customer_id: user.braintree_customer.id,
        payment_method_nonce: nonce,
        options: {
          make_default: true
        }
      )
    end
  end
end
