# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: profile_link_sites
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Metrics/LineLength

class ProfileLinkSite < ApplicationRecord
  has_paper_trail
  validates_presence_of :name
end
