require_dependency 'with_progress_bar'

module Zorro
  module Importer
    # Imports a follow from Aozora to Kitsu, and provides a way to import all follows at once.
    class FollowImporter
      include WithProgressBar

      # Import all follows into Kitsu
      def self.run!
        bar = progress_bar('Follows', follows_by_user)
        follows_by_user.each do |follow|
          new(follow).run!
          bar.increment
        end
        bar.finish
      end

      # Import both following and followers for a user into Kitsu
      # @param [User] the user whose follows to import
      def self.run_for(user)
        run_following_for(user)
        run_followers_for(user)
      end

      # Import a single user's following list into Kitsu
      # @param [User] the user whose follows to import
      def self.run_following_for(user)
        targets = Zorro::DB::Follow.find(owningId: user.ao_id).distinct('relatedId')
        new([user.ao_id], targets).run!
      end

      # Import a single user's followers list into Kitsu
      # @param [User] the user whose follows to import
      def self.run_followers_for(user)
        sources = Zorro::DB::Follow.find(relatedId: user.ao_id).distinct('owningId')
        new(sources, [user.ao_id]).run!
      end

      # @param follow [Hash<String,String>] the row from the follows aggregation
      def initialize(sources, targets)
        @follows = Zorro::Wrapper::FollowWrapper.new(sources, targets)
      end

      # Saves the post into the Kitsu database
      def run!
        @follows.save!
      end

      private

      def follows_by_user
        Zorro::DB::Follow.find.batch_size(5000).aggregate([
          {
            '$group': {
              _id: '$owningId',
              following: { '$addToSet': '$relatedId' }
            }
          }
        ])
      end
    end
  end
end
