require 'rails_helper'

RSpec.describe LikingFeedPostsBadge do
  let!(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:like) { create(:post_like, user: user, post: post) }

  describe 'rank 1' do
    it 'show rank' do
      subject { Bestowment.where(user: user, badge_id: 'LikingFeedPostsBadge').first }
      expect(subject.progress).to eq(1)
    end

    it 'create bestowment' do
      expect(Bestowment.all.count).to eq(1)
    end
  end
end
