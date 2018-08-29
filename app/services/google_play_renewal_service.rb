class GooglePlayRenewalService
  def initialize(token)
    @token = token
  end

  def subscription
    @subscription ||= ProSubscription::GooglePlaySubscription.find_by(billing_id: @token)
  end

  def service
    @service ||= GooglePlaySubscriptionService.new(@token)
  end

  def call
    ProRenewalService.new(user).renew_for(service.start_date, service.end_date)
  end
end
