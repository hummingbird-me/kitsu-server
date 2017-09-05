require_dependency 'zorro'
require_dependency 'zorro/wrapper/post'

module Zorro
  module Importer
    class Post
      def self.run!
        Zorro::DB::Post.find.each do |post|
          new(post).run!
          puts post['_id']
        end
      end

      def initialize(post)
        @post = Zorro::Wrapper::Post.new(post)
      end

      def run!
        @post.save!
      end
    end
  end
end
