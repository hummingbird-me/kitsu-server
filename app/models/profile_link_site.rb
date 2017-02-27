# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: profile_link_sites
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  validate_find    :string
#  validate_replace :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# rubocop:enable Metrics/LineLength

class ProfileLinkSite < ApplicationRecord
  has_paper_trail
  validates_presence_of :name, :validate_find, :validate_replace

  def validate_find
    Regexp.new(self[:validate_find]) unless self[:validate_find].nil?
  end
end
