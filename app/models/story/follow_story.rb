# frozen_string_literal: true

class Story
  class FollowStory < Story
    def follow
      @follow ||= Follow.find(data['follow_id'])
    end

    def target_feeds
      [follow.follower.feed_id]
    end
  end
end
