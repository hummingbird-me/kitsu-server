require_dependency 'zorro/wrapper/post'

module Zorro
  class Wrapper
    class MediaPost < Post
      def media
        Mapping.lookup('aozora', @data['parentID'])
      end

      def to_h
        super.merge(media: media)
      end
    end
  end
end
