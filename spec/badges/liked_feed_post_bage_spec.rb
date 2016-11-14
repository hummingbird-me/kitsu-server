require 'rails_helper'

RSpec.describe LikedFeedPostsBadge do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe 'rank 1' do
    before { create(:post_like, post: post) }

    it 'show rank, progress, title, description, goal' do
      badge = LikedFeedPostsBadge.new(user)
      expect(badge.rank).to eq(2)
      expect(badge.goal).to eq(5)
      expect(badge.progress).to eq(1)
      expect(badge.title).to eq('High Five')
        expect(badge.description).to eq('Give me 5! Your post has received' \
          ' 5 likes. Keep it up!')
    end

    it 'create bestowment' do
      expect(Bestowment.where(badge_id: 'LikedFeedPostsBadge').count).to eq(1)
    end
  end

  describe 'rank 2' do
    context 'when post liked 5 times' do
      before { 5.times { create(:post_like, post: post) } }

      it 'show rank, progress, title, description, goal' do
        badge = LikedFeedPostsBadge.new(user)
        expect(badge.rank).to eq(3)
        expect(badge.goal).to eq(10)
        expect(badge.progress).to eq(5)
        expect(badge.title).to eq('Group Hug')
        expect(badge.description).to eq('Please accept a warm hug from' \
          ' the community. Your post has earned 10 likes from the community.')
      end

      it 'create bestowment' do
        expect(Bestowment.where(
          badge_id: 'LikedFeedPostsBadge',
          rank: 2
        ).count).to eq(1)
        expect(Bestowment.where(
          badge_id: 'LikedFeedPostsBadge',
          rank: 1
        ).count).to eq(1)
      end
    end

    context 'when post liked 3 times' do
      before { 3.times { create(:post_like, post: post) } }

      it 'don\'t create bestowment' do
        expect(Bestowment.where(
          badge_id: 'LikedFeedPostsBadge',
          rank: 2
        ).count).to eq(0)
        expect(Bestowment.where(
          badge_id: 'LikedFeedPostsBadge',
          rank: 1
        ).count).to eq(1)
      end
    end
  end
end
