# frozen_string_literal: true

class Story
  class PostStory < Story
    def post
      @post ||= Post.find(data['post_id'])
    end

    def target_feeds
      group_or_user = post.target_group&.feed_id ||
                      post.target_user&.feed_id ||
                      post.user.feed_id
      media = post.media&.feed_id
      spoiled_unit = post.spoiled_unit&.feed_id

      [
        group_or_user,
        media,
        spoiled_unit
      ]
    end
  end
end
