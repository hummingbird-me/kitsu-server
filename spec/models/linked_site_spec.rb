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

require 'rails_helper'

RSpec.describe LinkedSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
