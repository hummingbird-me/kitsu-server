require_dependency 'with_progress_bar'

module Zorro
  module Importer
    # Imports a post from Aozora to Kitsu, and provides a way to import all posts in one fell swoop.
    class PostImporter
      include WithProgressBar

      # Import all posts from Aozora to Kitsu
      def self.run!
        Zorro::DB::POST_COLLECTIONS.each { |coll| run_for! coll }
      end

      # Import all posts from a collection into Kitsu
      # @param collection [Mongo::Collection] the collection to import from
      def self.run_for!(collection)
        bar = progress_bar(collection.name, collection.count)
        collection.find.each do |post|
          new(collection.name, post).run!
          bar.increment
        end
        bar.finish
      end

      # @param kind ['Post','TimelinePost','Thread'] the name of the post's collection
      # @param post [Hash] the document representing the post in Aozora
      def initialize(kind, post)
        klass = "Zorro::Wrapper::#{kind}Wrapper".safe_constantize
        @post = klass.wrap(post)
      end

      # Saves the post into the Kitsu database
      def run!
        @post.save!
      end
    end
  end
end
