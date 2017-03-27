class Stat < ApplicationRecord
  belongs_to :user, required: true
  # expose for jsonapi
  alias_attribute :kind, :type

  validates_presence_of :type, :stats_data

  def save_record
    new_record? ? save : update_attribute(:stats_data, stats_data)
  end
end
