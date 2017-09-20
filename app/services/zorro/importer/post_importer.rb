require_dependency 'with_progress_bar'

module Zorro
  module Importer
    # Imports a post from Aozora to Kitsu, and provides a way to import all posts in one fell swoop.
    class PostImporter
      include WithProgressBar

      # The collections we need to import posts from
      COLLECTIONS = [Zorro::DB::TimelinePost, Zorro::DB::Thread, Zorro::DB::Post].freeze

      # Import all posts from Aozora to Kitsu
      def self.run!
        COLLECTIONS.each { |coll| run_for! coll }
      end

      # Import all posts from a collection into Kitsu
      # @param collection [Mongo::Collection] the collection to import from
      def self.run_for!(collection)
        bar = progress_bar(collection.name, collection.count)
        collection.find.each do |post|
          new(post).run!
          bar.increment
        end
        bar.finish
      end

      # @param post [Hash] the document representing the post in Aozora
      def initialize(post)
        @post = Zorro::Wrapper::PostWrapper.wrap(post)
      end

      # Saves the post into the Kitsu database
      def run!
        @post.save!
      end
    end
  end
end
