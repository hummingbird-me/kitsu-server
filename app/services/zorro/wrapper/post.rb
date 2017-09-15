module Zorro
  class Wrapper
    class Post < BasePost
      # Wrap a Post in whichever delegate knows how to handle it properly
      #
      # @return [PostPost,PostComment,PostReply] the object wrapping the data
      def self.wrap(data)
        # Ignore posts involving Recommendations
        return if data['parentClass'] == 'Recommendation'
        # Normally replyLevel maps straight 0->Post, 1->Comment, but Anime threads have 0->Comment,
        # 1->Subcomment, so we push them down one, identifying them by lack of a parentClass.  This
        # makes the mappings now 0->Post, 1->Comment, 2->Subcomment
        reply_level = data['replyLevel']
        reply_level += 1 unless data['parentClass'].present?
        # Delegate based on reply level
        case reply_level
        when 0 then PostPost.new(data)
        when 1 then PostComment.new(data)
        when 2 then PostSubcomment.new(data)
        end
      end
    end
  end
end
