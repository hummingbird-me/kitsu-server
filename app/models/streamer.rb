# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: streamers
#
#  id                :integer          not null, primary key
#  logo_content_type :string
#  logo_file_name    :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  site_name         :string(255)      not null
#  created_at        :datetime
#  updated_at        :datetime
#
# rubocop:enable Metrics/LineLength

class Streamer < ApplicationRecord
  has_many :streaming_links
  has_many :videos

  validates :site_name, presence: true

  def self.find_by_name(name)
    Streamer.where('lower(site_name) = ?', name.downcase).first
  end
end
