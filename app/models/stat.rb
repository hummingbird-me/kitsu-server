class Stat < ApplicationRecord
  belongs_to :user, required: true
  # expose for jsonapi
  alias_attribute :kind, :type

  validates :type, :stats_data, presence: true
end
