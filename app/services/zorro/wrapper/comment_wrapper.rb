module Zorro
  class Wrapper
    class CommentWrapper < BasePost
      # @return [Post] the post that this is replying to
      def post
        Zorro::Cache.lookup(Post, @data['_p_parentPost'] || @data['_p_thread'])
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
