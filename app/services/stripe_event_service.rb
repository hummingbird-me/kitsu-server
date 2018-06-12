class StripeEventService
  def initialize(event)
    @event = event
  end

  def call
    case @event.type
    when 'invoice.payment_succeeded'
      StripeRenewalService.new(@event.object).call
    end
  end
end
