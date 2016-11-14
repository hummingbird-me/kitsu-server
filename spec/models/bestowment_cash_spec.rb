# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: bestowment_cashes
#
#  id         :integer          not null, primary key
#  number     :integer
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  badge_id   :string
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe BestowmentCash, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
