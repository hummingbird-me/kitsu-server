# == Schema Information
#
# Table name: bestowment_cashes
#
#  id         :integer          not null, primary key
#  number     :integer          default(0), not null
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  badge_id   :string           not null
#

class BestowmentCash < ActiveRecord::Base
  validates :badge_id, presence: true
  validates :badge_id, uniqueness: {
    scope: :rank,
    message: 'should be one per rank'
  }

  def inc
    self.number += 1
    save
  end
end
