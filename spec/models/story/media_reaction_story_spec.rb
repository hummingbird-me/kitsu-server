# frozen_string_literal: true

RSpec.describe Story::MediaReactionStory do
  describe '#media_reaction' do
    it 'returns the media reaction' do
      media_reaction = create(:media_reaction)
      story = described_class.new(data: { media_reaction_id: media_reaction.id })

      expect(story.media_reaction).to eq(media_reaction)
    end
  end

  describe '#target_feeds' do
    it 'includes the user feed' do
      media_reaction = create(:media_reaction)
      story = described_class.new(data: { media_reaction_id: media_reaction.id })

      expect(story.target_feeds).to include(media_reaction.user.feed_id)
    end

    it 'includes the media feed' do
      media_reaction = create(:media_reaction)
      story = described_class.new(data: { media_reaction_id: media_reaction.id })

      expect(story.target_feeds).to include(media_reaction.media.feed_id)
    end
  end
end
