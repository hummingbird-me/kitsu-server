require 'rails_helper'

RSpec.describe ConsecutiveDaysBadge do
  let!(:user) { create(:user, last_login: 73.hours.ago) }

  describe 'rank 1' do
    before do
      user.update(last_login: 49.hours.ago)
      user.update(last_login: 25.hours.ago)
      user.update(last_login: 1.hours.ago)
    end

    it 'show rank, progress, title, description, goal' do
      badge = ConsecutiveDaysBadge::Rank1.new(user)
      expect(badge.rank).to eq(1)
      expect(badge.goal).to eq(3)
      expect(badge.progress).to eq(3)
      expect(badge.title).to eq('Filthy Casual')
      expect(badge.description).to eq('You\'ve visited Kitsu every day' \
        ' for 3 consecutive days. Happy to have you here!')
      expect(badge.earned?).to eq(true)
    end

    it 'create bestowment' do
      expect(
        Bestowment.where(badge_id: 'ConsecutiveDaysBadge::Rank1').count
      ).to eq(1)
    end
  end
end
