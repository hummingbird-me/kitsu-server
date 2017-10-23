module Zorro
  class Wrapper
    class TimelinePostWrapper < BasePost
      # Wrap a TimelinePost in whichever delegate knows how to handle it properly
      #
      # @return [TimelinePostWrapper,CommentWrapper,ReplyWrapper] the object wrapping the data
      def self.wrap(data)
        # Delegate based on reply level
        case data['replyLevel']
        when 0 then TimelinePostWrappper.new(data)
        when 1 then CommentWrapper.new(data)
        when 2 then ReplyWrapper.new(data)
        end
      end

      # @return [Anime,nil] the anime that this post is discussing
      def target_user
        Zorro::Cache.lookup(User, data['_p_userTimeline']) if data['type'] == 'publicPost'
      end

      def to_h
        super.merge(target_user_id: target_user).compact
      end
    end
  end
end
