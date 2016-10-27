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

require 'rails_helper'

RSpec.describe LinkedSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
