module StreamDump
  class Post < ::Post
    scope :for_user_aggr, ->(user) {
      where(target_user: user, target_group: nil)
    }
    scope :for_user, ->(user) {
      where(user: user, target_user: nil, target_group: nil)
    }
    scope :for_group, ->(group) {
      where(target_group: group, target_user: nil)
    }

    def stream_activity
      target_feed = if target_group_id? then GroupFeed.new(target_group_id)
                    elsif target_user_id? then ProfileFeed.new(target_user_id)
                    else ProfileFeed.new(user_id)
                    end
      media_feed = MediaFeed.new(media_type, media_id) if media_id
      as_post = becomes(::Post)
      target_feed.activities.new(
        time: updated_at,
        updated_at: updated_at,
        post_likes_count: post_likes_count,
        comments_count: comments_count,
        content: content,
        to: [media_feed],
        nsfw: nsfw,
        verb: 'post',
        object: as_post,
        foreign_id: as_post
      )
    end
  end
end
