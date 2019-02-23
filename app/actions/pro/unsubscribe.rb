module Pro
  class Unsubscribe < Action
    parameter :user, required: true, load: User
    parameter :reason, required: false
    delegate :pro_subscription, to: :user

    validate :validate_is_subscribed

    def call
      pro_subscription.cancel!

      # Returns the expiration time for the subscription
      { expires_at: user.pro_expires_at }
    end

    def validate_is_subscribed
      errors.add(:user, 'is not subscribed') if pro_subscription.blank?
    end
  end
end
