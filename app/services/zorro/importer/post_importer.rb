module Zorro
  module Importer
    class PostImporter
      def self.run!
        Zorro::DB::Post.find.each do |post|
          new(post).run!
          puts post['_id']
        end
      end

      def initialize(post)
        @post = Zorro::Wrapper::PostWrapper.wrap(post)
      end

      def run!
        @post.save!
      end
    end
  end
end
