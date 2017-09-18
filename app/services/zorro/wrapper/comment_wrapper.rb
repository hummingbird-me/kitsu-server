module Zorro
  class Wrapper
    class CommentWrapper < BasePost
      # @return [Post] the post that this is replying to
      def post
        Post.find_by(ao_id: @data['_p_parentPost'] || @data['_p_thread'])
      end

      def to_h
        super.merge(post: post).compact
      end
    end
  end
end
