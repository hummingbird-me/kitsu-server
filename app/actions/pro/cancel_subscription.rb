module Pro
  class CancelSubscription < Action
    parameter :subscription, required: true
    delegate :user, to: :subscription

    def call
      ProMailer.cancellation_email(user, subscription.tier).deliver_later
      subscription.cancel!

      { subscription: subscription }
    end
  end
end
