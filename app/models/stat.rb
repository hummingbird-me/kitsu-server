class Stat < ApplicationRecord
  belongs_to :user, required: true

  validates :type, presence: true
  # removed validation for stats_data.
end
