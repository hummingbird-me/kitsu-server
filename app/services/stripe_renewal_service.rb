class StripeRenewalService
  delegate :user, to: :subscription

  def initialize(invoice)
    @invoice = invoice
  end

  def subscription
    ProSubscription.where(customer_id: @invoice.customer, billing_service: :stripe).first
  end

  def call
    ProRenewalService.new(user).renew_for(@invoice.period_start, @invoice.period_end)
  end
end
