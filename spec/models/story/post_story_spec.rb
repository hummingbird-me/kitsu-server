# frozen_string_literal: true

RSpec.describe Story::PostStory do
  describe '#post' do
    it 'returns the post' do
      post = create(:post)
      story = described_class.create!(data: { post_id: post.id })

      expect(story.post).to eq(post)
    end
  end

  describe '#target_feeds' do
    context 'when the post has a target group' do
      it 'includes the target group feed' do
        target_group = create(:group)
        post = create(:post, target_group:)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).to include(target_group.feed_id)
      end

      it 'does not include the post user feed' do
        target_group = create(:group)
        post = create(:post, target_group:)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).not_to include(post.user.feed_id)
      end
    end

    context 'when the post has a target user' do
      it 'includes the target user feed' do
        target_user = create(:user)
        post = create(:post, target_user:)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).to include(target_user.feed_id)
      end

      it 'does not include the post user feed' do
        target_user = create(:user)
        post = create(:post, target_user:)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).not_to include(post.user.feed_id)
      end
    end

    context 'when the post has no target user or group' do
      it 'includes the post user feed' do
        post = create(:post)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).to include(post.user.feed_id)
      end
    end

    context 'when the post has media' do
      it 'includes the media feed' do
        media = create(:anime)
        post = create(:post, media:)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).to include(media.feed_id)
      end

      it 'includes the user feed' do
        media = create(:anime)
        post = create(:post, media:)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).to include(post.user.feed_id)
      end
    end

    context 'when the post has a spoiled unit' do
      it 'includes the unit feed' do
        spoiled_unit = create(:chapter)
        post = create(:post, spoiled_unit:, media: spoiled_unit.manga)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).to include(spoiled_unit.feed_id)
      end

      it 'includes the user feed' do
        spoiled_unit = create(:chapter)
        post = create(:post, spoiled_unit:, media: spoiled_unit.manga)
        story = described_class.new(data: { post_id: post.id })

        expect(story.target_feeds).to include(post.user.feed_id)
      end
    end
  end
end
