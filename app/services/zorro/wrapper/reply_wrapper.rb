module Zorro
  class Wrapper
    class ReplyWrapper < BasePost
      # @return [Post] the post that this is replying to
      def post
        comment.post
      end

      # @return [Comment] the comment that this is replying to
      def comment
        Comment.find_by(ao_id: @data['_p_parentPost'])
      end

      def to_h
        super.merge(post: post).compact
      end
    end
  end
end
