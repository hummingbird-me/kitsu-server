require 'rails_helper'

RSpec.describe LikedFeedPostsBadge do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe 'rank 1' do
    before { create(:post_like, post: post) }

    it 'show rank, progress, title, description, goal' do
      badge = LikedFeedPostsBadge.new(user)
      expect(badge.rank).to eq(1)
      expect(badge.goal).to eq(5)
      expect(badge.progress).to eq(1)
      expect(badge.title).to eq('One of us')
      expect(badge.description).to eq('It\'s official, you\'re in! You' \
        ' received your first like from a member of the community.')
    end

    it 'create bestowment' do
      expect(Bestowment.where(badge_id: 'LikedFeedPostsBadge').count).to eq(1)
    end
  end

  describe 'rank 2' do
    before { 5.times { create(:post_like, post: post) } }

    it 'show rank, progress, title, description, goal' do
      badge = LikedFeedPostsBadge.new(user)
      expect(badge.rank).to eq(2)
      expect(badge.goal).to eq(10)
      expect(badge.progress).to eq(5)
      expect(badge.title).to eq('High Five')
      expect(badge.description).to eq('Give me 5! Your post has received' \
        ' 5 likes. Keep it up!')
    end
  end
end
