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

      # Import a single user's follows into Kitsu
      # @param [User] the user whose follows to import
      def self.run_for(user)
        ao_id = user.ao_id
        targets = Zorro::DB::Follow.find(owningId: ao_id).distinct('relatedId')
        new('_id' => source, 'following' => targets).run!
      end

      # @param follow [Hash<String,String>] the row from the follows aggregation
      def initialize(follow)
        source, targets = follow.values_at('_id', 'following')
        @follows = Zorro::Wrapper::FollowWrapper.new(source, targets)
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
