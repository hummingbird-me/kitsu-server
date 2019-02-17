class ProSubscription
  class BraintreeSubscription < ProSubscription
    def billing_service
      :braintree
    end

    def payment_method
      user.braintree_customer.payment_methods.find(&:default?)
    end

    alias_method :cancel!, :destroy!

    after_destroy do
      $braintree.subscription.cancel!(billing_id)
    end

    before_validation on: :create do
      self.billing_id = $braintree.subscription.create!(
        payment_method_token: payment_method.token,
        plan_id: "kitsu-#{tier}-yearly"
      ).id
    end
  end
end
