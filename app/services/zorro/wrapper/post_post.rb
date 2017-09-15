module Zorro
  class Wrapper
    class PostPost < BasePost
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
