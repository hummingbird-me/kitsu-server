class ProSubscription < ApplicationRecord
  class NoCancellationError < StandardError; end

  belongs_to :user, required: true
  enum tier: {
    pro: 1,
    patron: 2
  }
  enum state: {
    pending: 0, # Waiting for initial setup to complete
    current: 1, # Currently up-to-date on payments
    errored: 2  # Error during processing
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
