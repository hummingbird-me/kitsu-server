class ProSubscription
  class GooglePlaySubscription < ProSubscription
    def billing_service
      :google_play
    end

    def service
      @service ||= GooglePlaySubscriptionService.new(billing_id, tier)
    end

    after_destroy do
      service.cancel
    end
  end
end
