module Billing
  class UpdateBraintreePaymentMethod < Action
    parameter :user, required: true, load: User
    parameter :nonce, required: true

    def call
      $braintree.customer.update(user.braintree_customer.id, payment_method_nonce: nonce)
    end
  end
end
