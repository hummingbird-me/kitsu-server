class StripeRenewalService
  delegate :user, to: :subscription

  def initialize(invoice)
    @invoice = invoice
  end

  def subscription
    ProSubscription::StripeSubscription.find_by(billing_id: @invoice.subscription)
  end

  def call
    ProRenewalService.new(user).renew_for(@invoice.period_start, @invoice.period_end)
  end
end
