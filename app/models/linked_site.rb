# == Schema Information
#
# Table name: linked_sites
#
#  id         :integer          not null, primary key
#  link_type  :integer
#  name       :string
#  share_from :boolean
#  share_to   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LinkedSite < ActiveRecord::Base
  LINK_TYPE = %w[username OAuth2].freeze

  enum link_type: LINK_TYPE
end
