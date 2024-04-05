# frozen_string_literal: true

class Story
  class MediaReactionStory < Story
    def media_reaction
      @media_reaction ||= MediaReaction.find(data['media_reaction_id'])
    end

    def target_feeds
      [
        media_reaction.user.feed_id,
        media_reaction.media.feed_id
      ].compact
    end
  end
end
