class ProSubscription < ApplicationRecord
  belongs_to :user, required: true

  validates :type, presence: true
  validates :billing_id, presence: true

  def billing_service
    case self.class
    when ProSubscription::StripeSubscription then :stripe
    when ProSubscription::AppleSubscription then :apple_ios
    end
  end
end
