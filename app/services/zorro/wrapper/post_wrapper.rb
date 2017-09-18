module Zorro
  class Wrapper
    class PostWrapper < BasePost
      # Wrap a Post in whichever delegate knows how to handle it properly
      #
      # @return [Post,Comment,Reply] the object wrapping the data
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
        when 0 then new(data)
        when 1 then CommentWrapper.new(data)
        when 2 then ReplyWrapper.new(data)
        end
      end

      # @return [Anime,nil] the anime that this post is discussing
      def media
        Mapping.lookup('aozora', @data['parentID']) if @data['parentClass'] == 'Anime'
      end

      # @return [Episode,nil] the episode that this post is discussing
      def unit
        Mapping.lookup('aozora/episode', @data['parentID']) if @data['parentClass'] == 'Episode'
      end

      def to_h
        super.merge(media: media, unit: unit).compact
      end
    end
  end
end
