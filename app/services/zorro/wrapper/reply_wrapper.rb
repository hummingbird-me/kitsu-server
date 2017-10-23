module Zorro
  class Wrapper
    class ReplyWrapper < BasePost
      # @return [Post] the post that this is replying to
      def post
        comment.post
      end

      # @return [Comment] the comment that this is replying to
      def comment
        Zorro::Cache.lookup(Comment, @data['_p_parentPost'])
      end

      def to_h
        super.merge(post: post).compact
      end

      # Create the comment in our database
      # @return [Comment,nil] the comment that was created
      def save!
        Comment.create!(to_h) if save?
      end
    end
  end
end
