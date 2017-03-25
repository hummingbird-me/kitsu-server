class Stat < ApplicationRecord
  belongs_to :user, required: true
  # expose for jsonapi
  alias_attribute :kind, :type

  validates_presence_of :type, :stats_data
end
