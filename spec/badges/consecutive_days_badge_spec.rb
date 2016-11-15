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
      badge = ConsecutiveDaysBadge.new(user)
      expect(badge.rank).to eq(2)
      expect(badge.goal).to eq(30)
      expect(badge.progress).to eq(3)
      expect(badge.title).to eq('Enthusiast')
      expect(badge.description).to eq('Hey, we\'ve got a good thing going.' \
        ' You\'ve visited Kitsu every day for 30 consecutive days.')
    end

    it 'create bestowment' do
      expect(Bestowment.where(badge_id: 'ConsecutiveDaysBadge', rank: 1).count).to eq(1)
    end
  end
end
