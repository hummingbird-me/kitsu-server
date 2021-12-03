class ProMembershipPlan < ApplicationRecord
  scope :recurring, -> { where(recurring: true) }
  scope :nonrecurring, -> { where(recurring: false) }
end
