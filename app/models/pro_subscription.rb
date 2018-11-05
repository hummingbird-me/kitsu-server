class ProSubscription < ApplicationRecord
  belongs_to :user, required: true
  enum plan: {
    yearly: 0,
    monthly: 1
  }

  validates :type, presence: true
  validates :billing_id, presence: true

  def to_json(*args)
    {
      user: user_id,
      service: billing_service,
      plan: plan
    }.to_json(*args)
  end
end
