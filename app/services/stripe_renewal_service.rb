class StripeRenewalService
  delegate :user, to: :subscription

  def initialize(invoice)
    @invoice = invoice
  end

  def subscription
    ProSubscription::StripeSubscription.find_by(billing_id: @invoice.subscription)
  end

  def call
    ProRenewalService.new(user).renew_for(
      coerce_time(@invoice.period_start),
      coerce_time(@invoice.period_end)
    )
  end

  private

  # Stripe returns invoice period boundaries as Unix timestamps, while the test
  # mock serialises them as strings. Normalise both to Time.
  def coerce_time(value)
    case value
    when Numeric then Time.zone.at(value)
    when String then Time.zone.parse(value)
    else value
    end
  end
end
