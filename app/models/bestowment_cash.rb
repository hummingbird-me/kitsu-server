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

class BestowmentCash < ActiveRecord::Base
  validates :badge_id, presence: true
  validates :badge_id, uniqueness: { scope: :rank,
    message: "should be one per rank" }

  def inc
    self.number += 1
    self.save
  end
end
