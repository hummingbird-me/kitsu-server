class ProSubscription < ApplicationRecord
  belongs_to :user, required: true

  validates :type, presence: true
  validates :billing_id, presence: true

  def to_json(*args)
    {
      user: user_id,
      service: billing_service,
      plan: 'yearly'
    }.to_json(*args)
  end
end
