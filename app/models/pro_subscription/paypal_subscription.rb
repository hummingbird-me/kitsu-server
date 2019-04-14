class ProSubscription
  class PayPalSubscription < ProSubscription
    PayPal = PayPal::SDK::REST

    def billing_service
      :paypal
    end

    def agreement
      @agreement ||= PayPal::Agreement.find(billing_id)
    end

    alias_method :cancel!, :destroy!

    after_destroy do
      agreement.cancel!(note: 'Cancelled on website')
    end
  end
end
