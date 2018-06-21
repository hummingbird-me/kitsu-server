class ProSubscription < ApplicationRecord
  belongs_to :user, required: true

  validates :type, presence: true
  validates :billing_id, presence: true
end
