module Zorro
  class Wrapper
    class FollowWrapper < Wrapper
      # @param sources [Array<String>] Aozora IDs of the users to follow from
      # @param targets [Array<String>] Aozora IDs of the users to follow to
      def initialize(sources, targets)
        sources = Zorro::Cache.lookup(User, sources)
        targets = Zorro::Cache.lookup(User, targets)
        @follows = sources.product(targets)
      end

      # Add all the nonexistent follows to the database
      # @return [ActiveRecord::Import::Result] the results of the import
      def save!
        follows = []
        # Group the follows by source and build up a list of follows based on it
        @follows.group_by(&:first).each do |source, targets|
          targets = targets.map { |(_, target)| target }
          existing = Follow.where(follower: source, followed: targets).pluck(:followed_id)
          missing = targets - existing
          follows += missing.map { |target| [source, target] }
        end

        Follow.import(%i[follower_id followed_id], follows, validate: false)
        follows.each do |(follower_id, followed_id)|
          Feed.client.follow_many([{
            source: "timeline:#{follower_id}",
            target: "user:#{followed_id}"
          }], 50)
        end
      end
    end
  end
end
