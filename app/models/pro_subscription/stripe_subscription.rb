class ProSubscription
  class StripeSubscription < ProSubscription
    def billing_service
      :stripe
    end

    def subscription
      @subscription ||= Stripe::Subscription.retrieve(billing_id)
    end

    alias_method :cancel!, :destroy!

    after_destroy do
      subscription.delete
    end

    before_validation on: :create do
      self.billing_id = Stripe::Subscription.create(
        customer: user.stripe_customer.id,
        items: [{ plan: "#{tier}-yearly" }]
      ).id
    end
  end
end
