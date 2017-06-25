# == Schema Information
#
# Table name: bestowments
#
#  id         :integer          not null, primary key
#  earned_at  :datetime
#  progress   :integer          default(0), not null
#  rank       :integer          default(0), indexed => [user_id, badge_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  badge_id   :string           not null, indexed => [user_id, rank]
#  user_id    :integer          not null, indexed => [badge_id, rank]
#
# Indexes
#
#  index_bestowments_on_user_id_and_badge_id_and_rank  (user_id,badge_id,rank) UNIQUE
#
# Foreign Keys
#
#  fk_rails_5b7b2d53b8  (user_id => users.id)
#

class Bestowment < ActiveRecord::Base
  belongs_to :user, required: true

  validates :badge_id, presence: true

  after_create do
    BestowmentCash.first_or_create(
      badge_id: badge_id,
      rank: rank
    ).inc
  end

  def bestowed?
    !bestowed_at.nil? && bestowed_at < Time.now
  end

  def badge
    badge_id.safe_constantize.new(user)
  end

  def users_have
    all_users_count = User.count
    with_this_badge = Bestowment.where(badge_id: badge_id, rank: rank).count
    (with_this_badge.to_f / all_users_count.to_f) * 100
  end

  def rarity
    if users_have < 2
      'Epic'
    elsif users_have < 20
      'Rare'
    elsif users_have < 50
      'Uncommon'
    else
      'Common'
    end
  end

  def goal
    badge.goal
  end

  def progress
    badge.progress
  end
end
