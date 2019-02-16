module Billing
  class ProcessBraintreeWebhook < Action
    Kind = Braintree::WebhookNotification::Kind

    parameter :signature, required: true
    parameter :payload, required: true

    def call
      case kind
      when Kind::SubscriptionCanceled
        Pro::CancelSubscription.call(subscription: subscription) if subscription
      when Kind::SubscriptionChargedSuccessfully
        ProRenewalService.new(subscription.user).renew_for(
          event.subscription.billing_period_start_date,
          event.subscription.billing_period_end_date
        )
      when Kind::SubscriptionChargedUnsuccessfully
        Billing::NotifyIssue.call(subscription: subscription)
      end
    end

    def event
      @event ||= $braintree.webhook_notification.parse(signature, payload)
    end

    delegate :kind, to: :event

    def subscription
      @subscription ||= ProSubscription::BraintreeSubscription.find_by(
        billing_id: event.subscription.id
      )
    end
  end
end
