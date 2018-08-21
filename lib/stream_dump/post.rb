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

    def stream_id
      "Post:#{id}"
    end

    def notified_feeds
      []
    end

    def mentioned_users
      User.none
    end

    def other_feeds
      feeds = []
      feeds << GlobalFeed.new if user.share_to_global? && target_user.blank? && target_group.blank?
      # Limit media-feed fanout when targeting a unit
      feeds << (spoiled_unit ? media&.feed&.no_fanout : media&.feed)
      feeds << spoiled_unit&.feed
      feeds.compact
    end

    def complete_stream_activity
      super.tap do |act|
        act.verb = 'post'
      end
    end
  end
end
