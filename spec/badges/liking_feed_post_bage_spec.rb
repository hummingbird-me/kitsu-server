require 'rails_helper'

RSpec.describe LikingFeedPostsBadge do
  let!(:user) { create(:user) }

  describe 'rank 1' do
    before { create(:post_like, user: user) }

    it 'show rank, progress, title, description, goal' do
      badge = LikingFeedPostsBadge.new(user)
      expect(badge.rank).to eq(1)
      expect(badge.goal).to eq(10)
      expect(badge.progress).to eq(1)
      expect(badge.title).to eq('First like')
      expect(badge.description).to eq('You\'ve liked a comment, we like you.')
    end

    it 'create bestowment' do
      expect(Bestowment.where(badge_id: 'LikingFeedPostsBadge').count).to eq(1)
    end
  end

  describe 'rank 2' do
    before { 10.times { create(:post_like, user: user) } }

    it 'show rank, progress, title, description, goal' do
      badge = LikingFeedPostsBadge.new(user)
      expect(badge.rank).to eq(2)
      expect(badge.goal).to eq(50)
      expect(badge.progress).to eq(10)
      expect(badge.title).to eq('People Person')
      expect(badge.description).to eq('10 likes given! We love that' \
        ' you are spreading the love across the community. You\'re great!')
    end
  end
end
