# frozen_string_literal: true

RSpec.describe Story::FollowStory do
  describe '#follow' do
    it 'returns the follow' do
      follow = create(:follow)
      story = described_class.new(data: { follow_id: follow.id })

      expect(story.follow).to eq(follow)
    end
  end

  describe '#target_feeds' do
    it 'includes the follower feed' do
      follow = create(:follow)
      story = described_class.new(data: { follow_id: follow.id })

      expect(story.target_feeds).to include(follow.follower.feed_id)
    end
  end
end
