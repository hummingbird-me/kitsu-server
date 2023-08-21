# frozen_string_literal: true

class Streamer < ApplicationRecord
  has_many :streaming_links
  has_many :videos

  validates :site_name, presence: true

  scope :by_name, ->(*names) { where('lower(site_name) IN (?)', names.flatten.map(&:downcase)) }

  def self.find_by_name(name)
    Streamer.where('lower(site_name) = ?', name.downcase).first
  end
end
