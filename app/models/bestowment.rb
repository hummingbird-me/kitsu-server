# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: bestowments
#
#  id          :integer          not null, primary key
#  bestowed_at :datetime
#  progress    :integer          default(0), not null
#  rank        :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  badge_id    :string           not null
#  user_id     :integer          not null
#
# Foreign Keys
#
#  fk_rails_5b7b2d53b8  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class Bestowment < ActiveRecord::Base
  belongs_to :user, required: true

  validates :rank, :progress, :badge_id, presence: true
  validates :badge_id, uniqueness: { scope: :user_id }

  def bestowed?
    bestowed_at < Time.now
  end

  def badge
    badge_id.safe_constantize
  end

  def self.update_for(badge)
    bestowment = first_or_create(badge_id: badge.class, user: badge.user)
    bestowment.update(
      rank: badge.rank,
      progress: badge.progress,
      bestowed_at: DateTime.now
    )
  end
end
