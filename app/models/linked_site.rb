# == Schema Information
#
# Table name: linked_sites
#
#  id         :integer          not null, primary key
#  link_type  :integer          not null
#  name       :string           not null
#  share_from :boolean          default(FALSE), not null
#  share_to   :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LinkedSite < ApplicationRecord
  enum link_type: %i[username oauth2]
end
