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

require 'rails_helper'

RSpec.describe Bestowment, type: :model do
  let!(:user) { create :user }

  describe '.prepare_for' do
    before { Bestowment.prepare_for(user) }

    it 'create bestowments for all badges for user' do
      Bestowment::BADGES.each do |badge|
        expect(
          Bestowment.where(
            user: user,
            badge_id: badge
          ).first
        ).to_not be(blank?)
      end
    end
  end
end
