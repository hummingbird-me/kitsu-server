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
  enum link_type: %i[username oauth2]

  validates_presence_of :name
  validates_presence_of :link_type
end
