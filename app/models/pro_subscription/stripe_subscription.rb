class ProSubscription
  class StripeSubscription < ProSubscription
    def subscription
      @subscription ||= Stripe::Subscription.retrieve(billing_id)
    end

    after_destroy do
      subscription.delete
    end

    before_validation on: :create do
      self.billing_id = Stripe::Subscription.create(
        customer: user.stripe_customer.id,
        items: [{ plan: 'pro-yearly' }]
      ).id
    end
  end
end
