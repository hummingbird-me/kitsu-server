class ProSubscription < ApplicationRecord
  belongs_to :user, required: true
  enum billing_service: %i[stripe ios]

  validates :billing_service, presence: true
  validates :billing_id, presence: true
end
