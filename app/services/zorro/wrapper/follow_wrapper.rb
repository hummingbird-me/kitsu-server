module Zorro
  class Wrapper
    class FollowWrapper < Wrapper
      # @param source [String] Aozora ID of the source user
      # @param targets [Array<String>] Aozora IDs of the users to follow
      def initialize(source, targets)
        @source = source
        @targets = targets
      end

      # @return [User] the user who is doing the follow
      def follower
        @follower ||= Zorro::Cache.lookup(User, @source)
      end

      # @return [ActiveRecord::Relation<User>] the users who have been followed
      def followed
        @followed ||= Zorro::Cache.lookup(User, @targets)
      end

      private

      # @return [ActiveRecord::Relation<Follow>] any existing follows from the list
      def existing
        @existing ||= Follow.where(follower: follower, followed: followed)
      end

      # Add all the nonexistent follows to the database
      # @return [ActiveRecord::Import::Result] the results of the import
      def save!
        missing = followed - existing.pluck(:followed_id)
        columns = %i[follower_id followed_id]
        values = missing.map { |followed_id| [follower, followed_id] }
        Follow.import(columns, values, validate: false)
      end
    end
  end
end
