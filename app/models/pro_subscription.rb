class ProSubscription < ApplicationRecord
  class NoCancellationError < StandardError; end

  belongs_to :user, optional: false
  enum tier: {
    pro: 1,
    patron: 2
  }

  validates :type, presence: true
  validates :billing_id, presence: true
  validates :tier, presence: true

  def cancel!
    raise NoCancellationError
  end

  def to_json(*args)
    {
      user: user_id,
      service: billing_service,
      tier: tier
    }.to_json(*args)
  end
end
